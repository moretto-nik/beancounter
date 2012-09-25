class ApplicationSettings < ActiveRecord::Base
  attr_accessible :api_name, :api_value

  require "uri"
  require "net/http"

  def generate_beancounter_api_key
    RestClient.post('http://api.beancounter.io/rest/application/register',{
      :name => 'beancounter_demo',
      :description => 'beancounter demo application',
      :email => 'test@test.io',
      :oauthCallback => 'http://localhost:3000' 
    }) do | req, res, result|
      if result.code == "200"
        api_key = JSON.parse(req.body)["object"]
        self.api_value = api_key
        self.save
      else
        false
      end
    end
  end

  def self.get_profile(token, username)
    RestClient.get("http://api.beancounter.io/rest/user/#{username}/profile?token=#{token}") do |req, res, result|
      debugger
      puts
    end
  end

  def self.get_user_data(token, username)
    RestClient.get("http://api.beancounter.io/rest/user/#{username}/me?token=#{token}") do |req, res, result|
      if result.code == "200" && JSON.parse(req.body)["status"] == "OK"
        JSON.parse(req.body)["object"]["metadata"]
      end
    end
  end
end
