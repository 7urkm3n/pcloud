require 'json'
require 'rest-client'
require_relative './request'
require_relative "./files/file_handler"

module Pcloud
  class Client
    attr_writer :username, :password
    attr_accessor :auth_token, :base_url

    def initialize(options = {})
      @username, @password = options.values_at(:username, :password)
      @auth_token = options[:auth_token]
      @base_url = options[:base_url] || BASE_URL
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
      @http_client ||= RestClient::Resource.new(base_url)
    end

    def authenticate(options = {})
      @auth_token = authorize(options)['auth']
      self
    end

    def request(verb, path, params, payload = {})
      Pcloud::Request.call(self, verb, path, params, payload)
    end

  private
    def authorize(options)
      raise ConfigurationError, :username unless @username
      raise ConfigurationError, :password unless @password
      digest = JSON.parse(RestClient.get("#{base_url}/getdigest"))['digest']
      passworddigest = digest_data(@password + digest_data( @username.downcase ) + digest)
      [:username, :digest, :passworddigest, :password].each { |k| options.delete(k) }
      params = {params: {
        username: @username,
        digest: digest,
        passworddigest: passworddigest,
        device: "pcloud-ruby",
        getauth: 1
      }.merge!(options)}
      JSON.parse(RestClient.get("#{base_url}/userinfo", params)) #['auth']
    end

    def digest_data text
      Digest::SHA1.hexdigest(text)
    end

  end
end
