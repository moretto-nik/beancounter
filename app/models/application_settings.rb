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

  def self.check_status
    RestClient.get("http://api.beancounter.io/rest/api/check") do |req, res, result|
      result.code == "200" && JSON.parse(req.body)["status"] == "OK"
    end
  end

  def self.version
    RestClient.get("http://api.beancounter.io/rest/api/version") do |req, res, result|
      if result.code == "200" && JSON.parse(req.body)["status"] == "OK"
        JSON.parse(req.body)["object"]
      end
    end
  end
end
