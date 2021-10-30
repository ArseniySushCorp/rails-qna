Rails.application.routes.draw do
  use_doorkeeper
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

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[] do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, only: %i[index create show destroy update] do
        resources :answers, shallow: true, only: %i[create show destroy update]
      end
    end
  end
end
