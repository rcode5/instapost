#!/usr/bin/env ruby

require 'aws-sdk'
require 'platform-api'
require 'pry'
require 'yaml'

OAUTH_TOKEN = ENV['HEROKU_PLATFORM_API_TOKEN']
AWS_ACCESS_KEY_ID = ENV["AWS_ACCESS_KEY_ID"]
AWS_SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY']
ADMIN_EMAIL = ENV['INSTAPOST_ADMIN_EMAIL']
ADMIN_PASSWORD = ENV['INSTAPOST_ADMIN_PASSWORD']

domains = %w|callie.rocks ellap.rocks fulton.rocks harperc.rocks jennmeyer.rocks oliverh.rocks ryanc.rocks ryley.rocks waltv.rocks|

class AWSClient
  def initialize
    @client = AWS::S3.new(access_key_id: AWS_ACCESS_KEY_ID,
                          secret_access_key: AWS_SECRET_ACCESS_KEY)
  end

  def create_bucket(name)
   @client.buckets.create(name) unless @client.buckets[name.to_s].exists?
  end

end
  
class HerokuClient 
  def initialize
    @client = PlatformAPI.connect_oauth(OAUTH_TOKEN)
  end

  def method_missing(method, *args)
    if (@client.respond_to? method)
      @client.send(method, *args)
    else
      super
    end
  end
end

class AppConfigurator
  def initialize(domain)
    @domain = domain
    @app_name = "instapost-for-#{domain.gsub(/\.rocks/, '')}"
    @config = YAML.load_file("secret/heroku_config.yml").merge({INSTAPOST_BUCKET: @app_name, MAILER_HOST: @domain})
    @heroku = HerokuClient.new
    @aws = AWSClient.new
    @admin_email = ADMIN_EMAIL
    @admin_password = ADMIN_PASSWORD
  end

  def name
    @app_name
  end

  def configure
    create
    update_bucket
    update_config
    heroku_run "sharing:add jon\@bunnymatic.com"
    heroku_run "domains:add www.#{domain}"
  end

  def heroku_run(cmd)
    system "heroku #{cmd} --app=#{name}"
  end

  def setup_admin_user
    if ADMIN_EMAIL.nil? && ADMIN_PASSWORD.nil?
      raise "You must set INSTAPOST_ADMIN_EMAIL and INSTAPOST_ADMIN_PASSWORD in your environment before running this task."
    else
      heroku_run "run rake casein:users:create_admin email=#{ADMIN_EMAIL} password=#{ADMIN_PASSWORD}"
    end
  end

  def deploy
    push
    migrate
  end

  def push
    system "git push git@heroku.com:#{name}.git master"
  end

  def migrate
    heroku_run "run rake db:migrate"
  end

  def create
    if !exists?
      @heroku.app.create(name: name)
    end
  end

  def update_bucket
    @aws.create_bucket name
  end

  def update_collaborators
    @heroku.collaborator.create name, email: 'jon@bunnymatic.com'
    @heroku.collaborator.create name, email: 'jon@rcode5.com'
  end

  def update_config
    @heroku.config_var.update name, @config
  end
                         
  def info
    begin
      @heroku.app.info(name)
    rescue Excon::Errors::NotFound
      # heroku app doesn't exist yet
    end
  end

  def exists?
    !info.nil?
  end
   
end


if (ARGV.any?)
  desired = ARGV.map{|d| "#{d}.rocks"}
  domains.select!{|d| desired.include? d}
end

domains.each do |domain|

  app = AppConfigurator.new(domain)
  print "Configuring #{app.name}..."
  app.configure
  puts "done"

  print "Deploying #{app.name}..."
  app.deploy
  puts "done"

  print "Setting up admin users..."
  app.setup_admin_user
  puts "done"
end
