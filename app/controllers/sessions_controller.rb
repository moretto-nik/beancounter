# encoding: utf-8
class SessionsController < ApplicationController
  
  #sign_in_path
  def new
    if current_user!=nil
      redirect_to user_path(:username => current_user.username, :token => current_user.token), alert: "You are already logged in!"
    end
  end

  def create
    current_user = User.new(:token => params[:token], :username => params[:username])
    if current_user.get_user_data
      session[:user] = current_user
      redirect_to user_path(:username => current_user.username, :token => current_user.token), notice: "Signed in!"
    else
      redirect_to sign_in_path, alert: "Account already connected!"
    end
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
