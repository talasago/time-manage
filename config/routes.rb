Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/contact',        to: 'static_pages#contact'
  post   '/users/new',      to: 'users#create'
  get    '/login',          to:  'sessions#new'
  post   '/login',          to:  'sessions#create'
  delete '/logout',         to:  'sessions#destroy'
  post   '/act_historys/new',    to:  'activity_historys#create'
  get    '/act_historys',         to:  'activity_historys#show'

  resources :users
end
