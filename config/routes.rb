Rails.application.routes.draw do
  resource :signup, only: %i[create]
  resources :authentications, only: %i[create]
  resources :users, only: %i[index destroy] do
    member do
      put :archive
      put :unarchive
    end
  end
end
