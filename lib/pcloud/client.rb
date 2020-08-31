require 'json'
require 'rest-client'
require 'pcloud/exceptions'

module Pcloud
  class Client
    attr_writer :username, :password

    def initialize(options)
      @username, @password = options.values_at(:username, :password)
    end

    def get(path, params = {})
      resource(path).get(params)
    end

    def post(path, params = {})
      resource(path).post(params)
    end
    
    def http_client
      @client ||= begin
        RestClient::Resource.new(BASE_URL)
      end
    end

    def auth
      @auth ||= begin
        raise ConfigurationError, :username unless @username
        raise ConfigurationError, :password unless @password
        digest = JSON.parse(RestClient.get("#{BASE_URL}/getdigest"))['digest']
        passworddigest = Digest::SHA1.hexdigest( @password + Digest::SHA1.hexdigest( @username.downcase ) + digest)
        params = {params: 
          {
            username: @username, 
            digest: digest,
            passworddigest: passworddigest
          }
        }
        JSON.parse(RestClient.get("#{BASE_URL}/userinfo?getauth=1&logout=1", params))['auth']
      end
    end

    private

    def resource(path)
      Resource.new(self, path)
    end

  end
end
