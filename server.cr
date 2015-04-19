require "cgi"
require "http/server"

module Server
  class Base
    getter params

    def initialize
      @params   = {} of String => Array(String)
      @actions  = [] of Response
      @location = ""
      @method   = nil
    end

    def run(port)
      server = HTTP::Server.new port, do |request|
        begin
          p request

          action = @actions.find {|response| response.method == (@method || request.method) && 
                                             response.match_path?(request.path.to_s) }

          if action
            action.params_from_request = CGI.parse(request.body.to_s)
            if action.path == "GET"
              @method = nil
              HTTP::Response.ok "text/html", action.block.call(action.get_params)
            else
              @method = "GET"
              HTTP::Response.new 307, action.block.call(action.get_params), HTTP::Headers{"Location": @location}
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
        @actions << Response.new("{{method.id}}".upcase, 
                                 route.to_s, 
                                 route.to_s.scan(/(:.+?(?=\/))/).map(&.[](0)), 
                                 block)
        yield(params)
      end
    {% end %}

    def redirect_to(route)
      @location = route
    end
  end

  class Response
    property path
    property method
    property params
    property block
    setter params_from_request

    def initialize(@method, @path, @params, @block)
    end

    def get_params
    end

    def match_path?(path)
      return true
    end
  end
end
