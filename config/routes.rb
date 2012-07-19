Beancounter::Application.routes.draw do
  match "/users/:name" => "users#show", as:"user"
  match "/users/:name/publish" => "users#facebook_publish", as:"user_facebook_publish"
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'sign_in', to: 'sessions#new', as: 'sign_in'
  match 'sign_out', to: 'sessions#destroy', as: 'sign_out'
  root :to => redirect('/sign_in')
end
