class ApplicationController < ActionController::Base
  protect_from_forgery

  def signed_in?
    current_user != nil
  end

  def signed_in
    unless signed_in?
      render "public/550", :formats => [:html], :status => 550
    end
  end

  def is_user?
    current_user.id == session[:user_id].to_i
  end

  def require_user
    unless is_user?
      render "public/550", :formats => [:html], :status => 550
    end
  end

  #TODO Da elimianare
  def active_beancounter?
    if ApplicationSettings.find_by_api_name("beancounter")
      true
    else
      beancounterAPI = ApplicationSettings.new(:api_name => "beancounter")
      beancounterAPI.generate_beancounter_api_key
    end
  end

  #TODO Da eliminare
  def require_active_beancounter_api
    unless active_beancounter?
      render "public/404", :formats => [:html], :status => 404
    end
  end

private
  
  def current_user
    @current_user ||= session[:user] if session[:user]
  end
  helper_method :current_user
end
