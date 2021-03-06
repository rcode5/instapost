require 'platform-api'
module Instapost
  class HerokuClient 
    OAUTH_TOKEN = ENV['HEROKU_PLATFORM_API_TOKEN']

    def initialize
      @client = PlatformAPI.connect_oauth(OAUTH_TOKEN)
    end

    def rake(cmd, app_name)
      run "run rake #{cmd}", app_name
    end

    def run(cmd, app_name)
      system "heroku #{cmd} --app=#{app_name}"
    end

    def method_missing(method, *args)
      if (@client.respond_to? method)
        @client.send(method, *args)
      else
        super
      end
    end
  end
end
