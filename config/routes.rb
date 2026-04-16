Rails.application.routes.draw do
  root "posts#index"

  devise_for :users

  resource :profile, only: [ :show, :update ]
  resources :profiles, only: [ :show ]
  resources :users, only: [ :index, :show ]

  resources :notifications, only: [ :index ] do
    member do
      post :mark_as_read
    end
    collection do
      post :mark_all_as_read
    end
  end

  resources :conversations, only: [ :index, :show, :create ] do
    resources :direct_messages, only: [ :create ]
  end

  resources :posts do
    resources :comments, only: [ :create, :destroy ]
    resources :chat_rooms, only: [] do
      resources :messages, only: [ :create ]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
