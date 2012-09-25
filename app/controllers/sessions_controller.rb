# encoding: utf-8
class SessionsController < ApplicationController
  
  #sign_in_path
  def new
    if current_user!=nil
      redirect_to user_path(current_user.name), alert: "Sei già loggato!"
    end
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

  def test_bc
    result = ApplicationSettings.get_user_data(params[:token], params[:username])
    puts result
    render :text => result
  end
end
