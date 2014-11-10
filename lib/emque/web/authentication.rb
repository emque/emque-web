require "rack/auth/basic"

module Emque
  class Web
    class Authentication < Rack::Auth::Basic
      def call(env)
        Emque::Web.config.authentication ? super(env) : @app.call(env)
      end
    end

    use Emque::Web::Authentication, "Restricted Area" do |username, password|
      username == config.username && password == config.password
    end
  end
end
