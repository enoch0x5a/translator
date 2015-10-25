Rails.application.routes.draw do
  post 'sessions/create'

  get 'sessions/destroy'

  resources :translations
  resources :users


  # root 'translate#translate'
  root 'translate#translate'
  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'sign_in' => 'users#new', :as => 'sign_in'
  post 'translations/save' => 'translations#save'
  get 'translations/save' => 'translations#save'
  get '/dirs' => 'translations#dirs'
end
