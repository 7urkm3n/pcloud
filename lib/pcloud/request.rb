module Pcloud
  class Request
    def initialize(client, verb, path, params)
      @client, @verb , @path, @params = client, verb, path, params
    end

    def call
      params = {params: {}}
      params[:params].merge!(@params, {auth: @client.auth})

      http = @client.http_client
      res = case @verb
            when :get
              http[@path].get( params )
            when :post
              http[@path].post( params )
            else
              raise "Unsupported verb"
            end
      body = res.body ? res.body.chomp : nil
      handle_response(res.code.to_i, body)
    end
  
    private

    def handle_response(status_code, body)
      case status_code
      when 200
        return JSON.parse(body, { symbolize_names: true })
      when 202
        return body.empty? ? true : JSON.parse(body, { symbolize_names: true })
      when 400
        raise Error, "Bad request: #{body}"
      when 401
        raise AuthenticationError, body
      when 404
        raise Error, "404 Not found (#{@uri})"
      when 407
        raise Error, "Proxy Authentication Required"
      when 413
        raise Error, "Payload Too Large > 10KB"
      else
        raise Error, "Unknown error (status code #{status_code}): #{body}"
      end
    end

  end
end
