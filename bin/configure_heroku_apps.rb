#!/usr/bin/env ruby

require 'platform-api'
require 'pry'
require 'yaml'

OAUTH_TOKEN = ENV['HEROKU_PLATFORM_API_TOKEN']

domains = %w|callie.rocks ellap.rocks fulton.rocks harperc.rocks jennmeyer.rocks oliverh.rocks ryanc.rocks ryley.rocks waltv.rocks|

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

class HerokuApp < HerokuClient
  def initialize(app_name) 
    @app_name = app_name
    @config = YAML.load_file("secret/heroku_config.yml")
    super()
  end
  
  def create
    if !exists?
      self.app.create(name: @app_name)
    end
  end

  def update_config
    self.config_var.update @app_name, @config["aws"]
  end
                         
  def info
    begin
      self.app.info(@app_name)
    rescue Excon::Errors::NotFound
      # heroku app doesn't exist yet
    end
  end

  def exists?
    !info.nil?
  end
   
end


domains.each do |domain|

  prefix = domain.gsub(/\.rocks/, '')
  app = HerokuApp.new "instapost-for-#{prefix}"
  app.create
  app.update_config
  
end
