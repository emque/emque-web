require "faraday"

module Emque
  class Web
    class Source
      attr_reader :errors, :host, :app

      def initialize(host)
        self.host = host
        self.workers = {}
        self.errors = -1
        self.app = :unknown
      end

      def status
        Thread.new {
          begin
            get("/status")
          rescue
            # nothing to see here
          end
        }
      end

      def up(topic_name)
        Thread.new {
          status.join
          if has_topic?(topic_name)
            get("/control/#{topic_name}/up", :timeout => 10)
          end
        }
      end

      def down(topic_name)
        Thread.new {
          status.join
          if has_topic?(topic_name)
            get("/control/#{topic_name}/down", :timeout => 10)
          end
        }
      end

      def topics
        workers.keys
      end

      def has_topic?(name)
        topics.include?(name.to_sym)
      end

      def to_hsh
        {
          :app => app,
          :host => host,
          :errors => errors,
          :workers => workers
        }
      end
      alias :to_h :to_hsh

      private

      attr_accessor :workers
      attr_writer :errors, :host, :app

      def connection
        Faraday.new(:url => 'http://'+host) do |conn|
          conn.request :url_encoded
          conn.response :logger
          conn.adapter Faraday.default_adapter
        end
      end

      def get(url, timeout: 0)
        response = connection.get { |req|
          req.url url
          req.options.timeout = Emque::Web.config.timeout + timeout
          req.options.open_timeout = Emque::Web.config.timeout
        }

        response.on_complete do |env|
          process_status_json(env.body)
        end
      end

      def process_status_json(json_str)
        json = Oj.load(json_str)
        @workers = {}.tap { |workers|
          json["workers"].each do |key, value|
            workers[key.to_sym] = value
          end
        }
        @errors = json["errors"]["count"]
        @app = json["app"]
      end
    end
  end
end
