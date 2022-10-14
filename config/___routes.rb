Rails.application.routes.draw do
  resources :groups
  resources :settings
  devise_for :users
  resources :customers
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
   root 'customers#index'
end
