class Application < ActiveRecord::Base
  attr_accessible :api_key

  require "uri"
  require "net/http"

  def is_active?
  	if self.api_key == nil
      self.generate_api_key
    else
    	true
    end
  end

  def generate_api_key
    params = {'name' => 'beancounter_demo','description' => 'beancounter application','email' => 'test@test.io','oauthCallback' => 'http://localhost:3000'}
    response = JSON.parse(Net::HTTP.post_form(URI.parse('http://api.beancounter.io/rest/application/register'), params).body)
    if response['status'] == "OK"
      self.update_attributes(:api_key => response['object'])
      return true
    end
    false
  end
end
