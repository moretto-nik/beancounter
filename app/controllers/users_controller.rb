# encoding: utf-8
class UsersController < ApplicationController
  before_filter :signed_in
  before_filter :require_user
  before_filter :require_active_beancounter_api

  def show
  	@application_settings = ApplicationSettings.find_by_api_name("beancounter")
    @user = User.find(session[:user_id])
    if @user.provider == "facebook"
      @user.populate_facebook_attribute
    end
    
    if @user.username_beancounter == nil
      if @user.register_api(@application_settings.api_value) == true
        redirect_to user_path(@user.name), notice: "L'utente è stato iscritto con successo alle API."
      else
        redirect_to user_path(@user.name), alert: "L'utente non è stato iscritto con successo alle API."
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
end