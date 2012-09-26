Beancounter::Application.routes.draw do
  match "/users" => "users#show", as:"user"
  match "/users/facebook/publish" => "users#facebook_publish", as:"user_facebook_publish"
  match "/users/twitter/publish" => "users#twitter_publish", as:"user_twitter_publish"
  match 'auth', to: 'sessions#create'
  match 'sign_in', to: 'sessions#new', as: 'sign_in'
  match 'sign_out', to: 'sessions#destroy', as: 'sign_out'
  root :to => redirect('/sign_in')
end
