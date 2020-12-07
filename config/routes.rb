Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :cancel_vote
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, shallow: true, concerns: %i[votable commentable] do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: [:destroy]
  resources :rewards, only: :index
end
