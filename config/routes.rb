Rails.application.routes.draw do
  get 'tutorial/tutorial_insert'
  get 'tutorial/tutorial_insert_create'
  get 'tutorial/tutorial_insert_kyoto'
  get 'tutorial/tutorial_insert_scene'
  get 'tutorial/tutorial_insert_other'
  get 'tutorial/tutorial_evaluation'
  get 'tutorial/tutorial_evaluation2'
  get 'tutorial/tutorial_evaluation_kyoto'
  get 'tutorial/tutorial_evaluation_scene'
  get 'tutorial/tutorial_evaluation_other'

  get 'home/point_manual'


  resources :doing_lists
  resources :vote_categories
  resources :categories
  resources :behaviors
  resources :states

  get 'user_behavior/click'

  get 'evaluation/index'
  get 'evaluation/new'

  get 'user_behavior/click'
  post 'evaluation/create'

  get 'tweet_insert/confirm'
  get 'tweet_insert/pending'
  get 'tweet_insert/reason'

  resources :tweet_insert

  get 'admin/pay'
  get 'admin/tweet'
  get 'admin/reason'
  get 'admin/message'
  get 'admin/tweet_url'
  get 'admin/category_index'
  get 'admin/user_list', to: 'admin#user_list'
  get 'admin/user_show', to: 'admin#user_show'

  get 'admin', to: 'admin#index'

  devise_for :users
  get 'home/index'

  post 'tweet_insert/store'

  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
