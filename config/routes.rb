EnterpriseSocialNetwork::Application.routes.draw do
  get "pages/home"

	get "users/invite" => "users#invite", as: "invite_user"
  post "users/send_invite" => "users#send_invite", as: "send_invite_user"
  resources :companies, :users, :user_sessions
  match 'login' => 'user_sessions#new', as: :login
  match 'logout' => 'user_sessions#destroy', as: :logout

	root to: "pages#home"
end
