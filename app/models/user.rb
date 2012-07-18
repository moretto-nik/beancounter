class User < ActiveRecord::Base
  attr_accessible :username_beancounter, :password_beancounter

  def self.from_omniauth(auth)
  	where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
  	create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
  	end
  end

  def register_api(api_key)
    username = "#{self.name}"
    password = "user#{self.id}pwd"
    params = {'username' => username,'password' => password, 'name' => self.name, 'surname' => self.name}
    response = JSON.parse(Net::HTTP.post_form(URI.parse('http://api.beancounter.io/rest/user/register?apikey='+api_key),params).body)
    if response['status'] == "OK"
      self.update_attributes(:username_beancounter => username, :password_beancounter => password)
      true
    else
      false
    end
  end

  def check_provider(api_key, provider)
    uri = URI.parse("http://api.beancounter.io/rest/user/#{self.username_beancounter}/#{provider}/check?apikey=#{api_key}")
    response = JSON.parse(Net::HTTP.get_response(uri).body)
    if response['status'] == "OK"
      true
    else
      false
    end
  end

  def tag_cloud(api_key)
    uri = URI.parse("http://api.beancounter.io/rest/user/#{self.username_beancounter}/profile?apikey=#{api_key}")
    response = JSON.parse(Net::HTTP.get_response(uri).body)
    if response['status'] == "OK"
      true
    else
      false
    end
  end

  def share_page_on_provider(api_key, provider)
    params = {'username' => username,'password' => password, 'name' => self.name, 'surname' => self.name}
    response = JSON.parse(Net::HTTP.post_form(URI.parse("http://api.beancounter.io/rest/activities/add/#{self.username_beancounter}?apikey=#{api_key}"),params).body)

    
  end
end
