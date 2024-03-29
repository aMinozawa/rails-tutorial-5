Rails.application.routes.draw do

  
  root 'static_pages#home'
  get '/help',       to: 'static_pages#help'
  get '/about',      to: 'static_pages#about'
  get '/contact',    to: 'static_pages#contact'
  get '/signup',     to: 'user#new'
  post '/signup',    to: 'user#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy' 
  resources :user
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
end
