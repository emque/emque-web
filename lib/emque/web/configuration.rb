module Emque
  class Web
    class Configuration
      attr_accessor :sources, :timeout, :username, :password, :authentication

      def initialize
        self.sources = ["localhost:10000"]
        self.timeout = 1
        self.authentication = false
        self.username = ""
        self.password = "password"
      end
    end
  end
end

