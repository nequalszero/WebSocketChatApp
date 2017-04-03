Rails.application.routes.draw do
  get 'chatroom_members/create'

  get 'chatroom_members/destroy'

  namespace :api, defaults: {format: :json} do
    resources :users, only: [:create]
    resource :session, only: [:create, :destroy]
    resources :chatrooms, only: [:create, :update]

    resources :chatrooms do
      resources :messages, only: [:create, :update]
      resources :chatroom_members, only: [:create, :destroy]
    end
  end

  root "static_pages#root"
end
