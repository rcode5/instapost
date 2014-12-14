require 'aws-sdk'
module Instapost
  class AWSClient
    AWS_ACCESS_KEY_ID = ENV["AWS_ACCESS_KEY_ID"]
    AWS_SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY']

    def initialize
      @client = AWS::S3.new(access_key_id: AWS_ACCESS_KEY_ID,
                            secret_access_key: AWS_SECRET_ACCESS_KEY)
    end

    def create_bucket(name)
      @client.buckets.create(name) unless @client.buckets[name.to_s].exists?
    end
  end
end
