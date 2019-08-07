Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  get '/users/on_duty', to: 'users#duty'
  get '/users/edit_system_info', to: 'users#edit_system_info'
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
      get 'attendances/edit_attendances'
      patch 'attendances/update_attendances'
      get 'attendances/edit_overtimes'
      patch 'attendances/update_overtimes'
      get 'attendances/logs'
      get 'approvals/edit_approvals'
      patch 'approvals/update_approvals'
    end
    resources :attendances do
      member do
        get 'edit_overtime'
        patch 'update_overtime'
      end
    end
    resources :approvals
  end
  
  resources :centers

  resources 'users', only: :index do
    collection { post :import }
  end
end