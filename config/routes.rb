Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:create]
    resource :session, only: [:create, :destroy]
    resources :chatrooms, only: [:index, :create, :update]
    resources :messages, only: [:index]

    resources :chatrooms do
      resources :messages, only: [:create, :update]
      resources :chatroom_members, only: [:index, :create, :destroy]
    end
  end

  root "static_pages#root"
end
