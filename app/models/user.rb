# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :username_beancounter, :password_beancounter

  #gestione api beancounter
  def register_api(api_key)
    password = "user#{self.id}pwd"
    path = 'http://api.beancounter.io/rest/user/register?apikey=' + api_key
    RestClient.post(path, {
      :api_key => api_key,
      :username => self.name,
      :password => password,
      :name => self.first_name,
      :surname => self.last_name
    }) do | req, res, result|
      self.update_attributes(:username_beancounter => username, :password_beancounter => password) if result.code=="200"
    end
  end

  def check_provider(api_key, provider)
    RestClient.get "http://api.beancounter.io/rest/user/#{self.username_beancounter}/#{provider}/check?apikey=#{api_key}" do | req, res, result|
      result.code == "200" && JSON.parse(req.body)["status"] == "OK"
    end
  end

  def tag_cloud(api_key)
    RestClient.get "http://api.beancounter.io/rest/user/#{self.username_beancounter}/profile?apikey=#{api_key}" do | req, res, result|
      result.code == "200" && JSON.parse(req.body)["status"] == "OK"
    end
  end
  #end api beancounter

  #generazione utenti tramite facebook e twitter
  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth['info']['name'].gsub(/ /,"_") if auth["provider"] == "facebook"
      user.name = auth['info']['nickname'] if auth["provider"] == "twitter"
      user.oauth_token = auth.credentials.token
      user.oauth_secret = auth["credentials"]["secret"] if auth["provider"] == "twitter"
      user.populate_twitter_attribute if auth["provider"] == "twitter"
      user.populate_facebook_attribute if auth["provider"] == "facebook"
    end
  end
  #end generazione utenti fb e tw
  
  #gestione utenti facebook
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
  #end gestione utenti facebook

  #gestione utenti twitter
  def twitter
    if provider == "twitter"
      @twitter ||= Twitter::Client.new(consumer_key:TWITTER_KEY, consumer_secret:TWITTER_SECRET, oauth_token: oauth_token, oauth_token_secret: oauth_secret)
    end
  end

  def populate_twitter_attribute
    debugger
    info = self.twitter.current_user
    name = info["name"].split
    self.first_name = name[0]
    self.last_name = name[1]
  end

  def tweet
    if self.twitter.update("Questa è la mia pagina beancounter")
      true
    else
      false
    end
  end
  #end gestione utenti twitter
end
