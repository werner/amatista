require "cgi"
require "http/server"
require "./request"
require "./response"

class Amatista::Base
  getter params

  def initialize
    @params   = {} of String => Array(String)
    @actions  = [] of Request
    @location = ""
  end

  def run(port)
    server = HTTP::Server.new port, do |request|
      begin
        p request

        response = Response.new(request)

        action = response.process_static(request.path.to_s)
        action = response.find_action(@actions) unless action

        return HTTP::Response.not_found unless action

        @params = response.process_params(action)

        response.process_request(action, @params, @location)

      rescue e
        HTTP::Response.error "text/plain", "Error: #{e}"
      end
    end
    server.listen
  end

  {% for method in %w(get post put delete patch) %}
    def {{method.id}}(route, &block : Hash(String, Array(String)) -> String)
      @actions << Request.new("{{method.id}}".upcase, route.to_s, block)
      yield(@params)
    end
  {% end %}

  def redirect_to(route)
    @location = route
  end
end
