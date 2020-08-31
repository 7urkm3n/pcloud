module Pcloud
  class Resource

    def initialize(client, path)
      @client, @path = client, path
    end

    def get(params)
      create_request(:get, params).call
    end

    def post(params)
      create_request(:post, params).call
    end
    
    private

    def create_request(verb, params)
      Request.new(@client, verb, @path, params)
    end

  end
end
