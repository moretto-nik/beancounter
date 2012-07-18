class SessionsController < ApplicationController
  
  #sign_in_path
  def new
  end

  #/auth/:provider/callback
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to user_path(user.name), notice: "Signed in!"
  end

  #sign_out_path
  def destroy
    session[:user_id] = nil
    redirect_to sign_in_path, notice: "Sign out!"
  end
end