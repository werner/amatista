require "cgi"
require "http/server"
require "./helpers"

module Amatista
  class Base
    getter params

    include Helpers

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
        route = Response.find_route(@routes, request.method, request.path.to_s) unless route

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

  end
end
