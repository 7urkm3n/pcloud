require "pcloud/files/file_handler"

module Pcloud
  class Resource

    def initialize(client, path = "")
      @client, @path = client, path
    end

    def get(params)
      create_request(:get, params).call
    end

    def post(params, payload = {})
      create_request(:post, params, payload).call
    end

    def file
      @file ||= FileHandler.new(@client)
    end
    
    private

    def create_request(verb, params, payload = {})
      Request.new(@client, verb, @path, params, payload)
    end

  end
end
