Rails.application.routes.draw do
  root 'homes#index'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  }
  resources :rooms, only:[:create, :destroy, :show]
  resources :relationships, only:[:create, :destroy]
  resources :entries, only:[:create, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
