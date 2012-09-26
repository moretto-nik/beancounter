class ApplicationSettings < ActiveRecord::Base
  attr_accessible :api_name, :api_value

  require "uri"
  require "net/http"

  def self.generate_beancounter_api_key
    RestClient.post('http://api.beancounter.io/rest/application/register',{
      :name => 'beancounter_demo',
      :description => 'beancounter demo application',
      :email => 'test@test.io',
      :oauthCallback => 'http://localhost:3000' 
    }) do | req, res, result|
      if result.code == "200"
        api_key = JSON.parse(req.body)["object"]
        ApplicationSettings.new(:api_name => "bc", :api_value => api_key).save
      else
        false
      end
    end
  end

  def self.api_key
    if ApplicationSettings.all.empty?
      generate_beancounter_api_key
    end
    ApplicationSettings.first.api_value
  end
end
