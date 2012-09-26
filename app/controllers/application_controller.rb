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
    current_user.username == session[:user].username
  end

  def require_user
    unless is_user?
      render "public/550", :formats => [:html], :status => 550
    end
  end

private
  def current_user
    @current_user ||= session[:user] if session[:user]
  end
  helper_method :current_user
end
