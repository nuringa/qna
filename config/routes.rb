Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :cancel_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: [:destroy]
  resources :rewards, only: :index
end
