Beancounter::Application.routes.draw do
  resources :users, :only => [:show]
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'sign_in', to: 'sessions#new', as: 'sign_in'
  match 'sign_out', to: 'sessions#destroy', as: 'sign_out'
  root :to => redirect('/sign_in')
end
