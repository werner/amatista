require "cgi"
require "http/server"

module Server
  class Base
    getter params

    def initialize
      @params   = {} of String => Array(String)
      @actions  = {} of Tuple => Hash(String, Array(String)) -> String
      @location = ""
      @method   = nil
    end

    def run(port)
      server = HTTP::Server.new port, do |request|
        begin
          p request
          @params = CGI.parse(request.body.to_s)

          action = { @method || request.method, request.path.to_s }

          if @actions.has_key?(action)
            if action[0] == "GET"
              @method = nil
              HTTP::Response.ok "text/html", @actions[action].call(@params)
            else
              @method = "GET"
              HTTP::Response.new 307, @actions[action].call(@params), HTTP::Headers{"Location": @location}
            end
          else
            HTTP::Response.not_found
          end
        rescue
          HTTP::Response.error "text/plain", "Error"
        end
      end
      server.listen
    end

    {% for method in %w(get post put delete patch) %}
      def {{method.id}}(route, &block : Hash(String, Array(String)) -> String)
        @actions[{"{{method.id}}".upcase, route.to_s}] = block
        yield(params)
      end
    {% end %}

    def redirect_to(route)
      @location = route
    end
  end
end
