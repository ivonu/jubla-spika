Rails.application.routes.draw do

  root 'application#index'

  get 'wissen', to: 'application#theory'
  get 'about', to: 'application#about'

  devise_for :users
  
  resources :users, except: [:create, :new]
  resources :news
  resources :links
  resources :programs

  resources :entries do
    collection do
      post :plan
      get :tags
    end
  end

end
