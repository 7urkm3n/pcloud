require 'RestClient'

module Pcloud
  class FileHandler
    def initialize(client)
      @client = client
    end

    def upload(params, payload)
      create_request(:post, 'uploadfile', params, payload).call
    end

    def download(params)
      url = params[:url]
      begin
        res = RestClient.get(url)
      rescue => e
        raise HTTPError.new(:HTTPError, e.message)
      end
      
      filename = params[:filename] ? params[:filename] : url.split("/").last
      File.open("#{params[:destination]}/#{filename}", 'wb' ) do |f|
        f.write res
      end
      res.code
    end

    private

    def create_request(verb, path, params, payload = {})
      Request.new(@client, verb, path, params, payload)
    end
    
  end
end
