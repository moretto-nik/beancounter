# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :username_beancounter, :password_beancounter

  def self.from_omniauth(auth)
  	where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
  	create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      #da sistemare username univoco e senza spazi
      user.name = auth["info"]["name"].split[0]
      user.oauth_token = auth.credentials.token
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

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end

  def populate_facebook_attribute
    info = self.facebook.get_object("me")
    self.first_name = info['first_name']
    self.last_name = info['last_name']
    self.sex = info['gender']
    self.email = info['email']
  end

  def post_on_facebook_wall
    if self.facebook.get_connection("me","permissions")[0]["publish_stream"]
      self.facebook.put_wall_post("Questa è la mia pagina beancounter")
      true
    else
      false
    end
  end
end
