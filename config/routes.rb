Rails.application.routes.draw do

  root 'application#index'

  get 'wissen', to: 'application#theory'
  get 'about', to: 'application#about'
  get 'new_idea', to: 'application#new_idea'

  devise_for :users
  
  resources :users, except: [:create, :new]
  resources :news
  resources :links

  resources :programs do
    collection do
      post :rate
    end
    get :new_entry
    resources :comments
  end

  resources :entries do
    collection do
      post :plan
      post :rate
      get :tags
    end
    resources :comments
  end

end
