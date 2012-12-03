# encoding: utf-8
class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

  attr_accessor :username,:token, :name, :provider
  attr_accessible :username,:token, :name, :provider

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def get_profile
    #RestClient.get("http://api.beancounter.io/rest/user/14656799/profile?token=4fb43eeb-d4df-45f8-919c-5d7d97a5106e") do |req, res, result|
    RestClient.get("http://194.116.82.81:8080/beancounter-platform/rest/user/#{username}/profile?token=#{token}") do |req, res, result|
      if result.code == "200" && JSON.parse(req.body)["status"] == "OK"
        return JSON.parse(req.body)['object']['interests'], JSON.parse(req.body)['object']['categories']
      end
    end
  end

  def get_user_data
    RestClient.get("http://194.116.82.81:8080/beancounter-platform/rest/user/#{username}/me?token=#{token}") do |req, res, result|
      if result.code == "200" && JSON.parse(req.body)["status"] == "OK"
        user_information = JSON.parse(req.body)['object']
        if ["twitter", "facebook"] - user_information['services'].keys == []
          self.name = "#{user_information['metadata']['twitter.user.name']}"
          if self.name.empty?
            self.name = "#{user_information['metadata']['facebook.user.firstname']} #{user_information['metadata']['facebook.user.lastname']}"
          end
          self.provider = :both
        elsif user_information['services'].keys == ["facebook"]
          self.name = "#{user_information['metadata']['facebook.user.firstname']} #{user_information['metadata']['facebook.user.lastname']}"
          self.provider = :facebook
        elsif user_information['services'].keys == ["twitter"]
          self.name = "#{user_information['metadata']['twitter.user.name']}"
          self.provider = :twitter
        end
      else
        false
      end
    end
  end

  def provider?(provider)
    return true if self.provider == :both
    if self.provider == provider
      return true
    else
      return false
    end
  end

  def public_page(service, message)
    true
  end
end
