require 'sidekiq/web'

Rails.application.routes.draw do


  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  mount Sidekiq::Web => '/sidekiq'

  scope "(:locale)", locale: /es|en|ru|ja/ do
    resources :forms do
      collection do 
        post :enqueue
      end 

      resources :responses, only: [:index, :show, :new, :create]
    end
  end     
  # Defines the root path route ("/")
  root "forms#index"
end
