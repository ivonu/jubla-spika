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
      get :add_existing_entry, controller: :program_entries
      get :add_new_entry, controller: :program_entries
    end

    resources :comments, only: [:create]
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
      post :destroy_final
      post :keep
    end

    resources :comments, only: [:create]
    resources :attachments, only: [:create, :destroy]
  end

  resources :program_entries, only: [:destroy] do
    member do
      post :move_up
      post :move_down
    end
  end

end
