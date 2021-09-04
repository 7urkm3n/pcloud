autoload 'Logger', 'logger'
require 'forwardable'
require_relative 'pcloud/client'

module Pcloud
  BASE_URL = 'https://api.pcloud.com'.freeze

  class << self
    extend Forwardable
    def_delegators :client, :auth_token=, :username=, :password=
    def_delegators :client, :get, :post, :file, :authenticate

    attr_writer :logger

    def client
      @client ||= Pcloud::Client.new
    end

    def logger
      @logger ||= begin
        log = Logger.new($stdout)
        log.level = Logger::INFO
        log
      end
    end

  end
end

require_relative './pcloud/version'
require_relative './pcloud/exceptions'
