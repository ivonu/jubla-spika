Rails.application.routes.draw do

  resources :entries

  root 'application#bootstrap'

  devise_for :users

  patch 'users/:id/update_role' => 'user#update_role', as: 'update_role'

  get 'users' => 'user#index'
end
