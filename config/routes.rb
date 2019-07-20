Rails.application.routes.draw do

  get 'approvals/create'

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
      get 'attendances/edit_attendances'
      patch 'attendances/update_attendances'
      get 'overtimes/edit_overtimes'
      patch 'overtimes/update_overtimes'
      get 'approvals/edit_approvals'
      patch 'approvals/update_approvals'
    end
    resources :attendances
    resources :overtimes
    resources :approvals
    resources :stamps
  end

  resources 'users', only: :index do
    collection { post :import }
  end
end