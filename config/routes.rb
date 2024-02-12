Rails.application.routes.draw do
  devise_for :users
  root to: "top#index"
  resources :users, only: [:edit, :update, :destroy]
  resources :groups do
    collection do
      get 'search'
    end
  end
  resources :members do
    collection do
      get 'search'
    end
  end
end
