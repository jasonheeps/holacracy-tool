Rails.application.routes.draw do
  root to: 'pages#user_dashboard'

  devise_for :users

  resources :user do
    get 'dashboard', to: 'pages#user_dashboard'
    get 'profile', to: 'pages#user_profile'
  end

  get 'overview', to: 'pages#overview'
  get 'admin_console', to: 'pages#admin_console'

  resources :circles, only: [:create, :index, :show, :edit, :update, :destroy]
  get 'circles/:id/new_circle', to: 'circles#new', as: 'new_circle'

  resources :roles, only: [:create, :index, :show, :edit, :update, :destroy]
  get 'circles/:id/new_role', to: 'roles#new', as: 'new_role'

  resources :employees, only: [:index, :show, :update]
  resources :shifts, only: [:new, :create, :edit, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
