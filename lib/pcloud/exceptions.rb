module Pcloud

  class Error < RuntimeError; end
  class ConfigurationError < Error
    def initialize(key)
      super "missing key `#{key}' in the client configuration"
    end
  end
  class HTTPError < Error
    def initialize(key, message)
      super "Error status `#{key}': #{message}"
    end
  end

end
