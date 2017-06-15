Rails.application.routes.draw do
  get 'evaluation/index'
  get 'evaluation/new'

  resources :tweet_insert

  get 'admin/user_list', to: 'admin#user_list'
  get 'admin/user_show', to: 'admin#user_show'

  get 'admin', to: 'admin#index'

  devise_for :users
  get 'home/index'

  post 'tweet_insert/store'

  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
