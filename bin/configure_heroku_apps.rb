#!/usr/bin/env ruby

require 'aws-sdk'
require 'platform-api'
require 'pry'
require 'yaml'

OAUTH_TOKEN = ENV['HEROKU_PLATFORM_API_TOKEN']
AWS_ACCESS_KEY_ID = ENV["AWS_ACCESS_KEY_ID"]
AWS_SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY']

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
  def initialize(app_name) 
    @app_name = app_name
    @config = YAML.load_file("secret/heroku_config.yml").merge({INSTAPOST_BUCKET: @app_name})
    @heroku = HerokuClient.new
    @aws = AWSClient.new
  end

  def name
    @app_name
  end

  def configure
    create
    update_bucket
    update_config
    heroku_run "sharing:add jon\@bunnymatic.com"
  end

  def heroku_run(cmd)
    system "heroku #{cmd} --app=#{name}"
  end

  def deploy
    push
    migrate
  end

  def push
    system "git push git@heroku.com:instapost-for-jennmeyer.git master"
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

  prefix = domain.gsub(/\.rocks/, '')
  app = AppConfigurator.new("instapost-for-#{prefix}")
  print "Configuring #{app.name}..."
  app.configure
  puts "done"

  print "Deploying #{app.name}..."
  app.deploy
  puts "done"
 
end
