Ojstats::Application.routes.draw do
  devise_for :users

  root to: 'standings#all_time'

  resources :standings do
    collection do
      get :week
      get :month
      get :year
      get :all_time
      get :custom
      get :user_filter
    end
  end
  resources :filters do
    collection do
      post :save
    end
  end

  resources :problems, only: :index

  resources :users, only: :show

  resources :online_judges do
    post :refresh, on: :member
  end
end
