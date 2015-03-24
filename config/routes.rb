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
    get :new_entry
  end

  resources :entries do
    collection do
      post :plan
      get :tags
    end
  end

end
