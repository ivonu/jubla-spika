Rails.application.routes.draw do

  root 'application#index'

  devise_for :users
  resources :users, except: [:create, :new]

  resources :entries
end
