# encoding: utf-8
class UsersController < ApplicationController
  before_filter :signed_in
  before_filter :require_user
  before_filter :require_active_beancounter_api

  def show
  	@application_settings = ApplicationSettings.find_by_api_name("beancounter")
    @user = User.find(session[:user_id])
    
    if @user.username_beancounter == nil
      if @user.register_api(@application_settings.api_value) == true
        flash.now[:notice] = "L'utente è stato iscritto con successo alle API."
      else
        flash.now[:notice] = "L'utente non è stato iscritto con successo alle API."
      end
    end
  end

  def facebook_publish
    @user = User.find(session[:user_id])

    if @user.post_on_facebook_wall
      redirect_to user_path(@user.name), notice: "La tua pagina è stata pubblicata su facebook"
    else
      redirect_to user_path(@user.name), alert: "La tua pagina non è stata pubblicata"
    end
  end

  def tweet_publish
    @user = User.find(session[:user_id])

    if @user.tweet
      redirect_to user_path(@user.name), notice: "La tua pagina è stata pubblicata su twitter"
    else
      redirect_to user_path(@user.name), alert: "La tua pagina non è stata pubblicata"
    end
  end
end