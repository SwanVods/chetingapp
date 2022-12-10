Rails.application.routes.draw do
  get 'chat/index'

  namespace :api do
    namespace :v1 do
      post 'chat/create', to: 'chat#create'
      get 'chat/show', to:'chat#show'
    end
  end

  root "chat#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
