Rails.application.routes.draw do
  get 'user' => "user#index"
  get 'user/followers'
  get 'user/following'
  get 'user/:id' => 'user#show'
  patch 'user/like' => 'user#add_liked_article'
  delete 'user/unlike' => 'user#remove_liked_article'

  post 'user/:id/follow' => 'user#follow'
  delete 'user/:id/unfollow' => 'user#unfollow'

  get "articles/myarticles", to:"articles#myarticles"

  resources :articles

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'

  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
