require "cgi"
require "http/server"

class Amatista::Base
  getter params

  def initialize
    @params   = {} of String => Array(String)
    @routes  = [] of Route
    @location = ""
  end

  def run(port)
    server = HTTP::Server.new port, do |request|
      p request
      process(request)
    end
    server.listen
  end

  def process(request)
    begin
      response = Response.new(request)

      route = response.process_static(request.path.to_s)
      route = response.find_route(@routes) unless route

      return HTTP::Response.not_found unless route

      @params = response.process_params(route)

      response.process_request(route, @params, @location)

    rescue e
      HTTP::Response.error "text/plain", "Error: #{e}"
    end
  end

  {% for method in %w(get post put delete patch) %}
    def {{method.id}}(path, &block : Hash(String, Array(String)) -> String)
      @routes << Route.new("{{method.id}}".upcase, path.to_s, block)
      yield(@params)
    end
  {% end %}

  def redirect_to(path)
    @location = path
  end
end
