Ojstats::Application.routes.draw do
  devise_for :users

  root to: 'standings#index'

  resources :standings

  resources :users, only: :show

  resources :online_judges do
    post :refresh, on: :member
  end
end
