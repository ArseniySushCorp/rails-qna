Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  get 'rewards/index'

  resources :questions, shallow: true do
    resources :answers, shallow: true, except: %i[index new] do
      patch 'set_best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
  resources :links, only: :destroy
end
