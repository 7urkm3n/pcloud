module Pcloud
  class Error < RuntimeError; end
  class AuthenticationError < Error; end
  class ConfigurationError < Error
    def initialize(key)
      super "missing key `#{key}' in the client configuration"
    end
  end
  class NotFoundError < Error
    def initialize(key, message)
      super "not found `#{key}' with value of #{message}"
    end
  end
  class HTTPError < Error
    def initialize(key, message)
      super "#{key} Bad request: #{message}"
    end
  end
end
