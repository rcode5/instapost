source 'https://rubygems.org'

# Heroku uses the ruby version to configure your application's runtime.
ruby '2.1.4'

gem 'unicorn'
gem 'rack-canonical-host'
gem 'rails', '~> 4.1.6'
gem 'pg'

gem 'slim-rails'
gem 'jquery-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'awesome_print'

gem 'casein', path: '/projects/casein' # github: 'rcode5/casein'  # until casein ups authlogic requirement and improved file_filed management
# included via casein
#gem 'sass-rails'
#gem 'bootstrap-sass'

gem 'paperclip'

group :production, :acceptance do
  gem 'rails_stdout_logging'
  gem 'heroku_rails_deflate'
end

group :test do
  gem 'fuubar'
  gem 'jasminerice', github: 'bradphelan/jasminerice'  # Latest release still depends on haml.
  gem 'capybara'
  #gem 'capybara-email'
  gem 'poltergeist'
  gem 'factory_girl_rails'
  #gem 'timecop'
  gem 'database_cleaner'
  gem 'simplecov'
end

group :test, :development do
  gem 'rspec-rails'
  #gem 'cane'
  #gem 'morecane'
end

group :development do
  gem 'pry'
  gem 'pry-byebug'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'foreman'
  gem 'launchy'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'guard', '~> 2'
  gem 'guard-rspec'
  gem 'guard-jasmine'
  gem 'guard-livereload'
  gem 'rb-fsevent'
  gem 'growl'
end
