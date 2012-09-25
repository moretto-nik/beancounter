# encoding: utf-8
class SessionsController < ApplicationController
  
  #sign_in_path
  def new
    if current_user!=nil
      #TODO sistemare il path una volta sistemata la show
      redirect_to test_bc_path(:username => current_user.username, :token => current_user.token), alert: "Sei già loggato!"
    end
  end

  #/auth/:provider/callback
  def create
    #TODO Il contenuto della test_bc andra' inserito qui!
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to user_path(user.name), notice: "Signed in!"
  end

  #sign_out_path
  def destroy
    session[:user] = nil
    redirect_to sign_in_path, notice: "Sign out!"
  end

  def test_bc
    current_user = User.new(:token => params[:token], :username => params[:username])
    session[:user] = current_user
    render :text => current_user.get_user_data
  end
end
