Rails.application.routes.draw do
  root "dashboard#index"

  resources :articles
  resources :messages
end
