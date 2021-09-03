autoload 'Logger', 'logger'
require 'forwardable'
require_relative 'pcloud/client'

module Pcloud
  BASE_URL = 'https://api.pcloud.com'.freeze

  class << self
    extend Forwardable
    def_delegators :client, :auth_token, :auth_token=
    # def_delegators :client, :username=, :password=
    def_delegators :client, :get, :post
    def_delegators :client, :file

    attr_writer :logger

    def logger
      @logger ||= begin
        log = Logger.new($stdout)
        log.level = Logger::INFO
        log
      end
    end

    def authenticate
      @authenticate ||= begin
        raise ConfigurationError, :username unless @username
        raise ConfigurationError, :password unless @password
        digest = JSON.parse(RestClient.get("#{BASE_URL}/getdigest"))['digest']
        passworddigest = digest_data(@password + digest_data( @username.downcase ) + digest)
        JSON.parse(
          RestClient.get("#{BASE_URL}/userinfo", {params: {
            username: @username, 
            digest: digest, 
            passworddigest: passworddigest,
            device: "pcloud-ruby",
            getauth: 1
            }})
        )['auth']
      end
    end

    # client only works under one client 
    def client
      @client ||= Pcloud::Client.new
    end

    # TODO: for multiple clients has to be done here!
  end
end

require_relative './pcloud/version'
require_relative './pcloud/exceptions'
