EnterpriseSocialNetwork::Application.routes.draw do
	get "users/invite" => "users#invite", as: "invite_user"
  resources :companies, :users, :user_sessions
  match 'login' => 'user_sessions#new', as: :login
  match 'logout' => 'user_sessions#destroy', as: :logout
end
