Rails.application.routes.draw do
  resources :users
  constraints subdomain: /.*/ do
    root 'posts#index'
  end
  resources :comments, only: %i[new create destroy]
  resources :posts do
    get :touch_first
  end
end
