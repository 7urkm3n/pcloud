require 'json'
require 'rest-client'
# require 'file/file'
# require "#{Dir.pwd}/lib/pcloud/files/file_handler"


module Pcloud
  class Client
    attr_writer :username, :password

    def initialize(options = {})
      @username, @password = options.values_at(:username, :password)
    end

    def get(path, params = {})
      resource(path).get(params)
    end

    def post(path, params = {})
      resource(path).post(params)
    end

    def file
      Resource.new(self).file()
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
        passworddigest = digest_data(@password + digest_data( @username.downcase ) + digest)
        JSON.parse(
          RestClient.get("#{BASE_URL}/userinfo?getauth=1&logout=1", 
          {params: {username: @username, digest: digest, passworddigest: passworddigest}})
        )['auth']
      end
    end

    private

    def resource(path)
      Resource.new(self, path)
    end

    def digest_data text
      Digest::SHA1.hexdigest(text)
    end
  end
end
