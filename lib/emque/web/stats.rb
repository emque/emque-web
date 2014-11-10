require "emque/web/source"

module Emque
  class Web
    class Stats
      def self.fetch
        new.status
      end

      def initialize
        self.sources = build_sources
      end

      def status
        load_statii
        sources.map(&:to_h)
      end

      def down(host, topic)
        src = source(host)
        src.down(topic).join if src
      end

      def up(host, topic)
        src = source(host)
        src.up(topic).join if src
      end

      private

      attr_accessor :sources

      def build_sources
        [].tap { |sources|
          Emque::Web.config.sources.each do |source|
            sources << Emque::Web::Source.new(source)
          end
        }
      end

      def load_statii
        sources.map(&:status).each(&:join)
      end

      def source(host)
        sources.select{|s| s.host == host}.first
      end
    end
  end
end
