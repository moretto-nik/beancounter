# encoding: utf-8
class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

  attr_accessor :username,:token, :name
  attr_accessible :username,:token, :name

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
        user_information = JSON.parse(req.body)['object']
        if ["twitter", "facebook"] - user_information['services'].keys == []
          self.name = "#{user_information['metadata']['twitter.user.name']}"
          if self.name.empty?
            self.name = "#{user_information['metadata']['facebook.user.firstname']} #{user_information['metadata']['facebook.user.lastname']}"
          end
        elsif user_information['services'].keys == ["facebook"]
          self.name = "#{user_information['metadata']['facebook.user.firstname']} #{user_information['metadata']['facebook.user.lastname']}"
        elsif user_information['services'].keys == ["twitter"]
          self.name = "#{user_information['metadata']['twitter.user.name']}"
        end
      else
        false
      end
    end
  end

  def provider?(provider)
    RestClient.get("http://api.beancounter.io/rest/user/100003116792021/#{provider}/check?apikey=#{ApplicationSettings.api_key}") do |req, res, result|
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
