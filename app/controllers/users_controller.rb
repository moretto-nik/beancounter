# encoding: utf-8
class UsersController < ApplicationController
  before_filter :signed_in
  before_filter :require_user

  def show
    current_user = User.new(:username => params[:username], :token => params[:token])
    @interests, @categories = current_user.get_profile
    @interests.sort_by! { |hsh| hsh["weight"] }
    @categories.sort_by! { |hsh| hsh["weight"] }
  end

  def facebook_publish
    service_publish("facebook", params[:message])
  end

  def twitter_publish
    service_publish("twitter", params[:message])
  end

  private
  def service_publish(service, message)
    #TODO sistemare il path valutare i parametri
    if current_user.public_page(service, message)
      redirect_to user_path(:token => current_user.token, :username => current_user.username), notice: "La tua pagina e' stata pubblicata su #{service}"
    else
      redirect_to user_path(), alert: "La tua pagina non e' stata pubblicata"
    end
  end
end
