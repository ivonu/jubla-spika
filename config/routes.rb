Rails.application.routes.draw do

  root 'application#index'

  get 'wissen', to: 'application#theory'
  get 'about', to: 'application#about'
  get 'contact', to: 'application#contact'
  get 'new_idea', to: 'application#new_idea'

  devise_for :users
  
  resources :users, except: [:create, :new]
  resources :news
  resources :links

  resources :programs do
    member do
      post :rate
    end

    get :new_entry
    get :existing_entry
    resources :comments
  end

  resources :entries do
    collection do
      get :tags
      get :not_published
    end

    member do
      post :plan
      post :rate
      post :publish
    end

    resources :comments
    resources :attachments, only: [:create, :destroy]
  end

end
