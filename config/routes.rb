Rails.application.routes.draw do

  resources :entries

  root 'application#bootstrap'

  devise_for :users, :controllers => { registrations: 'registrations' }

  get 'users' => 'user#index'
end
