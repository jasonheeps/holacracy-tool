Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :circles, only: [:index, :show]
  resources :roles, only: [:index, :show]
  resources :policies, only: [:index]
  resources :employees, only: [:index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
