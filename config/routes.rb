EnterpriseSocialNetwork::Application.routes.draw do
  resources :likes

  post "posts/:id/like" => "posts#like", as: "like_post"
  post "posts/:id/unlike" => "posts#unlike", as: "unlike_post"
	get "posts/render_comment_form" => "posts#render_comment_form"

  resources :posts

  resources :groups

  get "pages/home"

	get "users/invite" => "users#invite", as: "invite_user"
  post "users/send_invite" => "users#send_invite", as: "send_invite_user"

	put "groups/:id/join" => "groups#join", as: "join_group"
	put "groups/:id/decline" => "groups#decline", as: "decline_group"
  post "groups/invite" => "groups#invite", as: "invite_user_to_group"

  resources :companies, except: :new
  resources :users
  resources :user_sessions
  match 'login' => 'user_sessions#new', as: :login
  match 'logout' => 'user_sessions#destroy', as: :logout

	root to: "pages#home"
end
