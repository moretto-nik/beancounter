# encoding: utf-8
class UsersController < ApplicationController
  before_filter :signed_in
  before_filter :require_user
  before_filter :require_active_beancounter_api

  def show
    #TODO Da adattare la show alle nuove politiche
    @application_settings = ApplicationSettings.find_by_api_name("beancounter")
    @user = User.find(session[:user_id])
    
    if @user.username_beancounter == nil
      if @user.register_api(@application_settings.api_value) == true
        flash.now[:notice] = "L'utente è stato iscritto con successo alle API."
      else
        flash.now[:alert] = "L'utente non è stato iscritto con successo alle API."
      end
    end
  end

  def facebook_publish
    service_publish(facebook, params[:message])
  end

  def tweet_publish
    service_publish(twitter, params[:message])
  end

  private
  def service_publish(service, message)
    #TODO sistemare il path
    if current_user.public_page(service, message)
      redirect_to user_path(@user.name), notice: "La tua pagina � stata pubblicata su #{service}"
    else
      redirect_to user_path(@user.name), alert: "La tua pagina non è stata pubblicata"
    end
  end
end
