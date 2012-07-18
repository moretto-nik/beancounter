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
        redirect_to user_path(@user.name), notice: "L'utente è stato iscritto con successo alle API."
      else
        redirect_to user_path(@user.name), alert: "L'utente non è stato iscritto con successo alle API."
      end
    end
  end
end