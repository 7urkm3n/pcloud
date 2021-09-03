module Pcloud
  module Request
    class << self
      def call(client, verb, path, params, payload={})
        params = {params: {}.merge!(params, {auth: client.auth_token})}
        http = client.http_client
        res = case verb
              when :get
                begin
                  http[path].get(params)
                rescue => e
                  handle_response(e.http_code, e.message)
                end
              when :post
                begin
                  http[path].post(payload, params)
                rescue => e
                  handle_response(e.http_code, e.message)
                end
              else
                raise "Unsupported verb (get and post available): #{verb}"
              end
        return res.body if params[:params][:raw]
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
end
