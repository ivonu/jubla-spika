Rails.application.routes.draw do

  root 'application#bootstrap'

  devise_for :users, :controllers => { registrations: 'registrations' }

  get 'users' => 'user#index'
end
