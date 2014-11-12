require "erb"
require "yaml"
require "sinatra"
require "sinatra/base"

module Emque
  class Web < Sinatra::Base; end
end

require "emque/web/authentication"
require "emque/web/configuration"
require "emque/web/stats"

module Emque
  class Web
    set :root, File.expand_path(File.dirname(__FILE__) + "/../../web")
    set :public_folder, Proc.new { "#{root}/assets" }
    set :views, Proc.new { "#{root}/views" }

    class << self
      def configure(&block)
        instance_exec(&block)
      end

      def config
        @@config ||= Emque::Web::Configuration.new
      end
    end

    get "/" do
      erb :index
      # response with chip app which loads all the data, etc
    end

    get "/status" do
      [200, {}, [Oj.dump(Emque::Web::Stats.fetch, :compat => true)]]
    end

    put "/clear_errors" do
      render_stats do |stats|
        stats.host_action(:clear_errors, params["host"])
      end
    end

    put "/down" do
      render_stats do |stats|
        stats.host_action(:down, params["host"], params["topic"])
      end
    end

    put "/threshold/down" do
      render_stats do |stats|
        stats.host_action(:threshold_down, params["host"])
      end
    end

    put "/threshold/up" do
      render_stats do |stats|
        stats.host_action(:threshold_up, params["host"])
      end
    end

    put "/up" do
      render_stats do |stats|
        stats.host_action(:up, params["host"], params["topic"])
      end
    end

    # HELPERS

    def current_path
      @current_path ||= request.path_info.gsub(/^\//,'')
    end

    def h(text)
      ::Rack::Utils.escape_html(text)
    rescue ArgumentError => e
      raise unless e.message.eql?('invalid byte sequence in UTF-8')
      text.encode!('UTF-16', 'UTF-8', invalid: :replace, replace: '').encode!('UTF-8', 'UTF-16')
      retry
    end

    def root_path
      "#{env['SCRIPT_NAME']}/"
    end

    private

    def render_stats
      stats = Emque::Web::Stats.new
      yield stats if block_given?
      [200, {}, [Oj.dump(stats.status)]]
    end
  end
end

