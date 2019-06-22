Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  get '/users/on_duty', to: 'users#duty'
  post '/users/import', to: 'users#import'
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update
  end

  resources 'users', only: :index do
    collection { post :import }
  end
end