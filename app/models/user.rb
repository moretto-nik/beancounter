# encoding: utf-8
class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

  attr_accessor :username,:token
  attr_accessible :username,:token

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def get_profile
    RestClient.get("http://api.beancounter.io/rest/user/#{username}/profile?token=#{token}") do |req, res, result|
      debugger
      puts
    end
  end

  def get_user_data
    RestClient.get("http://api.beancounter.io/rest/user/#{username}/me?token=#{token}") do |req, res, result|
      if result.code == "200" && JSON.parse(req.body)["status"] == "OK"
        JSON.parse(req.body)["object"]["metadata"]
      end
    end
  end

  def check_provider(api_key, provider)
    #TODO Da verificare non abbiamo api_key
    RestClient.get("http://api.beancounter.io/rest/user/#{self.username_beancounter}/#{provider}/check?apikey=#{api_key}") do | req, res, result|
      result.code == "200" && JSON.parse(req.body)["status"] == "OK"
    end
  end

  def public_page(service, message)
    RestClient.post("http://api.beancounter.io/activities/add/#{username}", {
      :username  => username,
      :activity  => "{
          \"object\":
          {
                \"type\" :        \"the type of the activity\",
                \"name\" :        \"the name of the activity\",
                \"description\" : \"a simple description of the activity\",
                \"url\" :         \"the url for the activity\"
          },
          \"context\":
          {
                \"date\" :    \"#{Date.today}\",
                \"service\" : \"#{service}\",
                \"mood\" :    \"the mood of the user\"
          },
          \"verb\" : \"the kind of activity\"
      }",
      :token     => token,
    }) do |req, res, result|
      #TODO
    end
  end
end
