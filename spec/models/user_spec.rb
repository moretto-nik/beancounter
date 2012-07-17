require 'spec_helper'

describe User do
  before :all do
    @application = create(:application)
    @user = create(:user)
  end
  
  it 'register user with beancounter API', :vcr do
    @user.register_api(@application.api_key).should == true
  end
end
