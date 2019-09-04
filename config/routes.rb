Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/contact',        to: 'static_pages#contact'
  post   '/users/new',      to: 'users#create'
  get    '/login',          to:  'sessions#new'
  post   '/login',          to:  'sessions#create'
  delete '/logout',         to:  'sessions#destroy'
  post   '/act_histories/new',    to:  'activity_histories#create'
  get    '/act_histories',        to:  'activity_histories#show'
  patch  '/act_history',        to:  'activity_histories#update'
  post   '/act_history/edit',     to:  'activity_histories#edit'
  resources :users
end
