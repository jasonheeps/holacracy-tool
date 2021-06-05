Rails.application.routes.draw do
  root to: 'pages#user_dashboard'

  devise_for :users

  resources :user do
    get 'dashboard', to: 'pages#user_dashboard'
    get 'profile', to: 'pages#user_profile'
  end

  get 'overview', to: 'pages#overview'
  # get 'employees', to: 'employees#search'

  resources :circles, only: [:index, :show, :edit, :update]
  resources :roles, only: [:index, :show, :edit, :update]
  resources :employees, only: [:index, :show, :update]
  resources :shifts, only: [:new, :create, :edit, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
