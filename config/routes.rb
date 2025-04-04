Rails.application.routes.draw do
  get 'reward_items/create'
  get 'reward_items/update'
  get 'reward_items/destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Authentication routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # Registration routes
  get '/signup', to: 'users#new'
  resources :users, only: [:create]
  
  # Main resource routes
  resources :projects do
    # Fulfillment Dashboard routes
    get 'fulfillment_dashboard', to: 'fulfillment_dashboard#show', as: 'fulfillment_dashboard'
    patch 'fulfillment_dashboard/update_reward', to: 'fulfillment_dashboard#update_reward', as: 'fulfillment_dashboard_update_reward'
    patch 'fulfillment_dashboard/update_item_counts', to: 'fulfillment_dashboard#update_item_counts'
    
    # Fulfillment Wave routes
    resources :fulfillment_waves
    
    # Backer Item Fulfillment routes
    resources :pledges do
      resources :backer_item_fulfillments
      patch 'update_item_fulfillments', to: 'backer_item_fulfillments#update_for_backer'
    end
    
    post 'bulk_update_item_fulfillments', to: 'backer_item_fulfillments#bulk_update'
    post 'generate_fulfillments/:reward_id', to: 'backer_item_fulfillments#generate_for_reward', as: 'generate_fulfillments'
    
    # Fulfillment routes
    get 'fulfillment', to: 'fulfillment#index', as: 'fulfillment'
    patch 'fulfillment/update_reward', to: 'fulfillment#update_reward', as: 'update_reward_fulfillment'
    
    resources :rewards do
      resources :reward_items, only: [:create, :update, :destroy]
      
      collection do
        get 'fulfillment', to: 'rewards#fulfillment', as: 'fulfillment'
      end
      
      member do
        patch 'update_fulfillment', to: 'rewards#update_fulfillment', as: 'update_fulfillment'
      end
    end
    
    resources :pledges, only: [:new, :create]
    resources :surveys
    
    # Project dashboard routes
    get 'dashboard', to: 'project_dashboard#show', as: 'dashboard'
    get 'dashboard/backers', to: 'project_dashboard#backers', as: 'dashboard_backers'
    get 'dashboard/rewards', to: 'project_dashboard#rewards', as: 'dashboard_rewards'
  end
  
  resources :pledges, only: [:index, :show, :new, :create]
  
  # Dashboard routes
  get '/dashboard', to: 'dashboard#index'
  get '/dashboard/backed_projects', to: 'dashboard#backed_projects', as: 'backed_projects_dashboard'
  get '/dashboard/created_projects', to: 'dashboard#created_projects', as: 'created_projects_dashboard'
  post '/dashboard/set_active_tab', to: 'dashboard#set_active_tab', as: 'dashboard_set_active_tab'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Component library for UI documentation
  get "/component-library", to: "component_library#index", as: :component_library
  
  # Defines the root path route ("/")
  root "projects#index"
end
