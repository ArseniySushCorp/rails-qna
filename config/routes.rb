Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true, except: %i[index new] do
      patch 'set_best', on: :member
    end
  end
end
