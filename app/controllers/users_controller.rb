class UsersController < ApplicationController
  before_filter :signed_in
  before_filter :require_user

  def show
    
  end

end