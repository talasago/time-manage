Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/contact',        to:  'static_pages#contact'
  post   '/users/new',      to:  'users#create'
  get    '/terms',          to:  'static_pages#terms'
  get    '/privacy',        to:  'static_pages#privacy'
  get    '/login',          to:  'sessions#new'
  post   '/login',          to:  'sessions#create'
  delete '/logout',         to:  'sessions#destroy'
  get    '/users/:id/show_detail',          to:  'users#show_detail', as: 'user_show_detail'
  post   '/users/:id/act_histories/new',    to:  'activity_histories#create'
  get    '/users/:id/act_histories',        to:  'activity_histories#show'
  patch  '/users/:id/act_history',          to:  'activity_histories#update'
  delete '/users/:id/act_history',          to:  'activity_histories#destroy'
  post   '/users/:id/act_history/edit',     to:  'activity_histories#edit'
  resources :users
end
