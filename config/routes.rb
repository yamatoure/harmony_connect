Rails.application.routes.draw do
  devise_for :users
  root to: "top#index"
  resources :users, only: [:edit, :update, :destroy]
end
