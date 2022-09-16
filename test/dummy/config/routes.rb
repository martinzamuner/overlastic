Rails.application.routes.draw do
  root "dashboard#index"

  concern :articles do
    resources :articles do
      get :thank_you, to: "articles/thank_you#show"

      resources :comments, except: :index
    end
  end

  scope path: :dialogs, as: :dialogs do
    concerns :articles
  end

  scope path: :panes, as: :panes do
    concerns :articles
  end
end
