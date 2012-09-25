#TODO Da eliminare, non serve piu'
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
end
