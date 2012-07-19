EnterpriseSocialNetwork::Application.routes.draw do
  resources :companies

  resources :companies, :users, :user_sessions
  match 'login' => 'user_sessions#new', as: :login
  match 'logout' => 'user_sessions#destroy', as: :logout
end
