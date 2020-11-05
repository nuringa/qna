Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :best
      end
    end
  end
end
