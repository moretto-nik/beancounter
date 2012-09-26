# encoding: utf-8
class UsersController < ApplicationController
  before_filter :signed_in
  before_filter :require_user

  def show
    #TODO Da adattare la show alle nuove politiche
    
    #render :text => current_user.get_user_data
  end

  def facebook_publish
    service_publish("facebook", params[:message])
  end

  def twitter_publish
    service_publish("twitter", params[:message])
  end

  private
  def service_publish(service, message)
    #TODO sistemare il path
    if current_user.public_page(service, message)
      redirect_to user_path(@user.name), notice: "La tua pagina e' stata pubblicata su #{service}"
    else
      redirect_to user_path(@user.name), alert: "La tua pagina non e' stata pubblicata"
    end
  end
end
