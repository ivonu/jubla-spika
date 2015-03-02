Rails.application.routes.draw do

  root 'application#bootstrap'

  devise_for :users
  resources :users, except: [:create, :new]

  resources :entries
end
