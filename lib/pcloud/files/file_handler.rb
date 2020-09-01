# require File.dirname(__FILE__) + '/upload'
# puts "#{Dir.pwd}/lib/pcloud/request"
# require "#{Dir.pwd}/lib/pcloud/request"

module Pcloud
  class FileHandler
    def initialize(client)
      @client = client
    end

    def upload(params, payload)
      create_request(:post, 'uploadfile', params, payload).call
    end

    def download(params)
      # create_request(:get, 'downloadfile', params).call
      url = params[:url]
      filename = params[:filename] ? params[:filename] : url.split("/").last
      File.open("#{params[:destination]}/#{filename}", 'wb') {|f|
        block = proc { |response|
          response.read_body do |chunk|
            f.write chunk
          end
        }
        RestClient::Request.execute(method: :get,url: url,block_response: block)
      }
    end

    private

    def create_request(verb, path, params, payload = {})
      Request.new(@client, verb, path, params, payload)
    end
    
  end
end
