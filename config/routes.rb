Rails.application.routes.draw do

	#Casein routes
	namespace :casein do
		resources :posts
	end

  resources :posts, only: [:index]

  root 'posts#index'
end
