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
      devise_for :users, skip: :all, controllers: {
        sessions: "api/v1/sessions",
        registrations: "api/v1/registrations"
      }

      devise_scope :user do
        post "/users/sign_in", to: "sessions#create"
        delete "/users/sign_out", to: "sessions#destroy"
        post "/users", to: "registrations#create"
      end

      resources :activities, only: [ :index, :show, :create, :update, :destroy ] do
        post "join", on: :member, to: "activities#join"
        delete "leave", on: :member, to: "activities#leave"
        post "update_status", on: :member, to: "activities#update_status"

        post "generate_description", on: :collection, to: "activities#generate_description"
        get "/description_status/:request_id", on: :collection, to: "activities#description_status", as: :description_status
      end

      resources :users, only: [ :show ], param: :username
      resource :current_user, only: [ :show, :update, :destroy ]
    end
  end
end
