require Rails.root.join("config/environments/production")

Rails.application.configure do
  config.paperclip_defaults = {
    storage: :s3,
    #s3_host_name: ENV['AWS_HOST_NAME'] 
    s3_credentials: {
      bucket: 'instapostdev',
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_key_id: ENV['AWS_SECRET_KEY_ID']
    }
  }
  config.action_mailer.default_url_options = { host: 'insta-post-acceptance.herokuapp.com' }
end
