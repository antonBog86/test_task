# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  resource :account, only: :show

  resources :transactions, only: %i[create new index]

  # Defines the root path route ("/")
  root "accounts#show"
end
