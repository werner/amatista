require "cgi"
require "http/server"

class Amatista::Base
  getter params

  def initialize
    @params   = {} of String => Array(String)
    @routes  = [] of Route
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
      route = Response.find_route(@routes, request.path.to_s) unless route

      return HTTP::Response.not_found unless route

      @params = response.process_params(route)

      route.block.call(@params)
    rescue e
      HTTP::Response.error "text/plain", "Error: #{e}"
    end
  end

  {% for method in %w(get post put delete patch) %}
    def {{method.id}}(path, &block : Hash(String, Array(String)) -> HTTP::Response)
      @routes << Route.new("{{method.id}}".upcase, path.to_s, block)
      yield(@params)
    end
  {% end %}

  def redirect_to(path)
    route = Response.find_route(@routes, path)
    raise "#{path} not found" unless route
    HTTP::Response.new 307, "redirection", HTTP::Headers{"Location": path}
  end

  def respond_to(context, body)
    context = case context
              when :html then "text/html"
              else
                raise "#{context} not available"
              end

    HTTP::Response.ok context, body
  end
end
