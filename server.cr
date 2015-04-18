require "cgi"
require "http/server"

module Server
  class Base
    getter params

    def initialize
      @params  = {} of String => Array(String)
      @actions = {} of String => Hash(String, Array(String)) -> String
    end

    def run(port)
      server = HTTP::Server.new port, do |request|
        p request
        @params = CGI.parse(request.body.to_s)

        if @actions.has_key?(request.path.to_s)
          if request.method == "GET"
            HTTP::Response.ok "text/html", @actions[request.path.to_s].call(@params)
          elsif %w(POST PUT DELETE PATCH).includes? request.method
            HTTP::Response.new 307, @actions[request.path.to_s].call(@params)
          else
            HTTP::Response.error "text/plain", "Error"
          end
        else
          HTTP::Response.not_found
        end
      end
      server.listen
    end

    {% for method in %w(get post put delete patch) %}
      def {{method.id}}(route, &block : Hash(String, Array(String)) -> String)
        @actions[route.to_s] = block
        yield(params)
      end
    {% end %}

    def redirect_to(route)
      @actions[route].call(@params)
    end
  end
end
