Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#user_dashboard'
  
  resources :users do
    get 'dashboard', to: 'pages#user_dashboard'
    get 'profile', to: 'pages#user_profile'
  end

  get 'overview', to: 'pages#overview'
  get 'admin_console', to: 'pages#admin_console'
  get 'account_management', to: 'pages#account_management'

  #TODO: think about whether it makes sense to nest more routes within circles-routes

  resources :circles, only: [:create, :index, :show, :edit, :update, :destroy]
  get 'circles/:id/new_circle', to: 'circles#new', as: 'new_circle'

  resources :roles, only: [:create, :index, :show, :edit, :update, :destroy]
  get 'circles/:id/new_role', to: 'roles#new', as: 'new_role'

  resources :employees, only: [:new, :create, :index, :show, :update]

  resources :role_fillings, only: [:create, :edit, :update, :destroy]
  get 'roles/:id/new_role_filling', to: 'role_fillings#new', as: 'new_role_filling'

  # resources :shifts, only: [:new, :create, :edit, :update, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
