Rails.application.routes.draw do
  root "dashboard#index"

  resources :articles do
    get :thank_you, to: "articles/thank_you#show"
  end

  resources :messages
end
