Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users
  resources :user do
    get 'dashboard', to: 'pages#user_dashboard'
  end
  get 'overview', to: 'pages#overview'
  resources :circles, only: [:index, :show]
  resources :roles, only: [:index, :show]
  resources :employees, only: [:index, :show]
  resources :shifts, only: [:new, :create, :edit, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
