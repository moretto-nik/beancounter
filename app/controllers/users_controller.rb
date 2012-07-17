class UsersController < ApplicationController
  #before_filter :signed_in
  #before_filter :require_user
  before_filter :require_active_api

  def show
    
  end
end