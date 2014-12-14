require 'yaml'
require 'net/ping/http'

class PingError < StandardError; end
module Instapost
  class AppConfigurator

    ADMIN_EMAIL = ENV['INSTAPOST_ADMIN_EMAIL']
    ADMIN_PASSWORD = ENV['INSTAPOST_ADMIN_PASSWORD']

    def initialize(domain)
      @domain = domain
      @app_name = "instapost-for-#{@domain.gsub(/\.rocks/, '')}"
      @config = YAML.load_file("secret/heroku_config.yml").merge({INSTAPOST_BUCKET: @app_name, MAILER_HOST: @domain})
      @heroku = HerokuClient.new
      @aws = AWSClient.new
      @admin_email = ADMIN_EMAIL
      @admin_password = ADMIN_PASSWORD
    end

    def domain
      @domain
    end

    def www_domain
      'www.' + domain
    end

    def name
      @app_name
    end

    def heroku_run(cmd)
      @heroku.run_command cmd, name
    end

    def ping
      begin
        tries ||= 3
        ping!
        true
      rescue PingError => ex
        print "retrying in 1 second..."
        sleep(1)
        retry unless ((tries -=1) == 0)
        false
      end
    end

    def ping!
      raise PingError.new("Fail") unless Net::Ping::HTTP.new(www_domain).ping
    end

    def configure
      create
      update_bucket
      update_config
      heroku_run "sharing:add jon\@bunnymatic.com"
      heroku_run "domains:add #{www_domain}"
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
end
