require "mime"

module Amatista
  # Use by the framework to return an appropiate response based on the request.
  class Response
    property request

    def initialize(@request)
    end

    def self.find_route(routes, method, path_to_find)
      routes.find {|route_request| route_request.method == method && route_request.match_path?(path_to_find) }
    end

    def process_params(route)
      route.request_path = @request.path.to_s
      route.add_params(CGI.parse(@request.body.to_s))
      route.get_params
    end
  end
end
