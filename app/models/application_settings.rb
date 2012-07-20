class ApplicationSettings < ActiveRecord::Base
  attr_accessible :api_name, :api_value

  require "uri"
  require "net/http"

  def generate_beancounter_api_key
    params = {'name' => 'beancounter_demo','description' => 'beancounter application','email' => 'test@test.io','oauthCallback' => 'http://localhost:3000'}
    response = JSON.parse(Net::HTTP.post_form(URI.parse('http://api.beancounter.io/rest/application/register'), params).body)
    if response['status'] == "OK"
      self.api_value = response['object']
      if self.save 
        return true
      end
    else
      false
    end
  end
end
