Rails.application.routes.draw do
  root 'static_pages#home'

  get '/test', to: 'film#index'

end
