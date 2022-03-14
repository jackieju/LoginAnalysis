Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html 
 # resources :home
 # resources :gochart
  get '/:gochart', to: 'gochart#index' 
  post '/:gochart', to: 'gochart#index' 
end
