Rails.application.routes.draw do

  root 'user_sessions#new'

  resources :translations, except: [ :edit, :new ]
  resources :users, only: [ :create ]

  get 'login' => 'user_sessions#new', :as => 'login'
  post 'user_sessions/create'
  get 'logout' => 'user_sessions#destroy', :as => 'logout'
  get 'sign_up' => 'users#new', :as => 'sign_up'
  get 'sign_off' => 'users#destroy', :as => 'sign_off'
  post 'translations/save'
end
