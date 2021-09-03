require 'json'
require 'rest-client'
require_relative './request'
require_relative "./files/file_handler"

module Pcloud
  class Client
    attr_accessor :auth_token

    def initialize(options={})
      @auth_token = options.values_at(:auth_token)
    end

    def get(path, params={})
      request(:get, path, params)
    end

    def post(path, payload={}, params={})
      request(:post, path, params, payload)
    end

    def file
      @file ||= FileHandler.new(self)
    end

    def http_client
      @http_client ||= RestClient::Resource.new(BASE_URL)
    end

    # def auth
    #   @auth = "Yy5B2kZqbUxZ9N28XgnMh7VMp6jjhqb7oh2pv40V"
    #   # @auth ||= begin
    #   #   raise ConfigurationError, :username unless @username
    #   #   raise ConfigurationError, :password unless @password
    #   #   digest = JSON.parse(RestClient.get("#{BASE_URL}/getdigest"))['digest']
    #   #   passworddigest = digest_data(@password + digest_data( @username.downcase ) + digest)
    #   #   JSON.parse(
    #   #     RestClient.get("#{BASE_URL}/userinfo?getauth=1&logout=1", {params: {
    #   #       username: @username, 
    #   #       digest: digest, 
    #   #       passworddigest: passworddigest,
    #   #       device: "pcloud-ruby"
    #   #       }})
    #   #   )['auth']
    #   # end
    # end

    private

    def request(verb, path, params, payload = {})
      Pcloud::Request.call(self, verb, path, params, payload)
    end

    def digest_data text
      Digest::SHA1.hexdigest(text)
    end
  end
end
