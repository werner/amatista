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

          return HTTP::Response.not_found unless action

          action.params_from_request = CGI.parse(request.body.to_s)

          case action.method
          when "GET"
            @method = nil
            HTTP::Response.ok "text/html", action.block.call(action.get_params)
          when "POST", "PUT", "DELETE", "PATCH"
            @method = "GET"
            HTTP::Response.new 307, action.block.call(action.get_params), HTTP::Headers{"Location": @location}
          else
            raise "Path not Found"
          end
        rescue
          HTTP::Response.error "text/plain", "Error"
        end
      end
      server.listen
    end

    {% for method in %w(get post put delete patch) %}
      def {{method.id}}(route, &block : Hash(String, Array(String)) -> String)
        @actions << Response.new("{{method.id}}".upcase, route.to_s, block)
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

    def initialize(@method, @path, @block)
      @params_from_request = {} of String => Array(String)
    end

    def get_params
      @params_from_request
    end

    def match_path?(path)
      if path == "/"
        @path == "/"
      elsif @path != "/"
        route_to_match = Regex.new(@path.to_s.gsub(/(:\w*)/, ".*"))
        path.match(route_to_match)
      end
    end

    def extract_params(path)
      path.to_s.scan(/(:\w*)/).map(&.[](0))
    end
  end
end
