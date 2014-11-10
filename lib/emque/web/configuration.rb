module Emque
  class Web
    class Configuration
      attr_accessor :sources, :timeout

      def initialize
        self.sources = ["localhost:10000"]
        self.timeout = 1
      end
    end
  end
end

