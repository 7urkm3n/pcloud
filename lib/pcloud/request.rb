module Pcloud
  class Request
    def initialize(client, verb, path, params, payload)
      @client, @verb, @path, @params, @payload = client, verb, path, params, payload
    end

    def call
      params = {params: {}}
      params[:params].merge!(@params, {auth: @client.auth})
      http = @client.http_client
      res = case @verb
            when :get
              begin
                http[@path].get(params)
              rescue => e
                handle_response(e.http_code, e.message)
              end
            when :post
              begin
                http[@path].post(@payload, params)
              rescue => e
                handle_response(e.http_code, e.message)
              end
            else
              raise "Unsupported verb: #{@verb}"
            end
      JSON.parse(res.body, { symbolize_names: true })
    end

    private

    def handle_response(status_code, body)
      case status_code
      when 400
        raise HTTPError.new(:HTTPError, body)
      when 401
        raise AuthenticationError, body
      when 404
        raise HTTPError.new(:HTTPError, body)
      else
        raise Error, "Unknown error (status code #{status_code}): #{body}"
      end
    end

  end
end
