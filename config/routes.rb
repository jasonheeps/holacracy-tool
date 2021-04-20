Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'overview', to: 'pages#overview'
  resources :circles, only: [:index, :show]
  resources :roles, only: [:index, :show]
  resources :employees, only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
