Rails.application.routes.draw do
  root 'static_pages#home'
  get '/contact',        to: 'static_pages#contact'
  post '/users/new',     to: 'users#create'
  resources :users
end
