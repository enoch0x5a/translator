Rails.application.routes.draw do

  root 'sessions#new'

  resources :translations, except: [ :edit, :new ]
  resources :users, only: [ :create ]

  get 'login' => 'sessions#new', :as => 'login'
  post 'sessions/create'
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'sign_up' => 'users#new', :as => 'sign_up'
  get 'sign_off' => 'users#destroy', :as => 'sign_off'
  post 'translations/save'
end
