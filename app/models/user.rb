class User < ActiveRecord::Base
  attr_accessible :username, :password

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
    username = "user#{self.id}"
    password = "user#{self.id}pwd"
    params = {'username' => username,'password' => password, 'name' => self.name, 'surname' => self.name}
    response = JSON.parse(Net::HTTP.post_form(URI.parse('http://api.beancounter.io/rest/user/register?apikey='+api_key),params).body)
    if response['status'] == "OK"
      self.update_attributes(:username => username, :password => password)
      true
    else
      false
    end
  end
end
