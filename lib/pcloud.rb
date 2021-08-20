autoload 'Logger', 'logger'
require 'forwardable'
require 'pcloud/client'

module Pcloud
  BASE_URL = 'https://api.pcloud.com'.freeze

  class << self
    extend Forwardable
    def_delegators :client, :username=, :password=
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

    # client only works under one client 
    def client
      @client ||= Pcloud::Client.new
    end

    # TODO: for multiple clients has to be done here!

  end
end

require 'pcloud/version'
require 'pcloud/request'
require 'pcloud/exceptions'
require "pcloud/files/file_handler"
