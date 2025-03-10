Rails.application.routes.draw do
  devise_for :users
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        sessions: "api/v1/sessions",
        registrations: "api/v1/registrations"
      }

      resources :activities, only: [ :index, :show, :create, :update, :destroy ]
      resources :participants, only: [ :create ]
      resources :users, only: [ :show, :update, :destroy ]
    end
  end
end
