Rails.application.routes.draw do
  get 'user' => "user#index"
  get 'user/myprofile'
  get 'user/followers'
  get 'user/following'
  get 'user/:id' => 'user#show'
  patch 'user/like' => 'user#add_liked_article'
  delete 'user/unlike' => 'user#remove_liked_article'

  post 'user/:id/follow' => 'user#follow'
  delete 'user/:id/unfollow' => 'user#unfollow'

  get "articles/myarticles", to:"articles#myarticles"
  get "articles/recomended"
  get "articles/topics"
  get "articles/toparticles"
  get "articles/viewhistory"

  get "lists/mylists"
  post "lists/create" => 'lists#create'
  get "lists/:id/show" => 'lists#show'
  patch "lists/:id/add" => 'lists#add'
  delete "lists/:id/remove" => 'lists#remove'
  delete "lists/:id/deletelist" => 'lists#deletelist'

  post "payment/create"
  post "payment/verify", to:"payment#webhook"

  resources :articles

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'

  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
