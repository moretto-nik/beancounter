Beancounter::Application.routes.draw do
  #TODO Da verificare quali rotte sono da eliminare
  match "/users/:name" => "users#show", as:"user"
  match "/users/:name/facebook/publish" => "users#facebook_publish", as:"user_facebook_publish"
  match "/users/:name/twitter/publish" => "users#twitter_publish", as:"user_twitter_publish"
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'sign_in', to: 'sessions#new', as: 'sign_in'
  match 'sign_out', to: 'sessions#destroy', as: 'sign_out'
  match 'test_bc', to: 'sessions#test_bc', as:'test_bc'
  root :to => redirect('/sign_in')
end
