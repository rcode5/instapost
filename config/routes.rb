Rails.application.routes.draw do

	#Casein routes
	namespace :casein do
		resources :customizations
		resources :posts
	end

  resources :posts, only: [:index]
  resource :custom_styles, only: :show

  root 'posts#index'
end
