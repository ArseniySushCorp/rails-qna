Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  get 'rewards/index'

  resources :questions, shallow: true do
    resources :answers, shallow: true, except: %i[index new] do
      patch 'set_best', on: :member
      put :vote, votable_type: 'Answer', on: :member
      delete :cancel_vote, votable_type: 'Answer', on: :member
    end

    member do
      put :vote, votable_type: 'Question'
      delete :cancel_vote, votable_type: 'Question'
    end
  end

  resources :answers, only: %i[] do
    resources :comments, shallow: true, defaults: { commentable_type: 'Answer' }, only: %i[create destroy]
  end

  resources :questions, only: %i[] do
    resources :comments, shallow: true, defaults: { commentable_type: 'Question' }, only: %i[create destroy]
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
  resources :links, only: :destroy
end
