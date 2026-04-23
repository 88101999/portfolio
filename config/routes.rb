Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root 'static_pages#top'
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'
  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :password_resets, only: %i[new create edit update]
  # resources :questions, only: %i[new]
  # resources :answers, only: %i[create]
  get 'coordinates', to: 'coordinates#index'

  resources :bookmarks, only: %i[index create destroy]

  resources :diagnoses, only: [] do
    collection do
      get 'step/:step', to: 'diagnoses#show_step', as: :step
      post 'step/:step', to: 'diagnoses#update_step', as: :update_step
    end
  end

  resources :coordinates, only: %i[index show]

  post 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  get 'oauth/callback', to: 'oauths#callback'
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth'
end
