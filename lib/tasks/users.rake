namespace :users do
  desc "Load a small, representative set of data so that the application can start in an use state (for development)."
  task add: :environment do
    name = ENV['name']
    login = ENV['login']
    password = ENV['password']
    email = ENV['email']

    params = [name, login, password, email]
    if params.all?
      user_params = Hash[[:name, :login, :password, :email].zip(params)]
      user_params[:password_confirmation] = user_params[:password]
      Casein::AdminUser.create! user_params
    else
      puts "You must specify name, login, password and email (like email=joe@example.com)"
      exit -1
    end
  end
end
