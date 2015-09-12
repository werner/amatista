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
      route.add_params(objectify_params(CGI.parse(@request.body.to_s)))
      route.get_params
    end

    #Convert params get from CGI to a Crystal Hash object
    private def objectify_params(params) : Hash(String, Hash(String, String))
      result = {} of String => Hash(String, String)
      params.select {|k,v| k =~/\w*\[\w*\]/}
            .each do |key, value|
        object = key.match(/(\w*)\[(\w*)\]/) { |x| [x[1], x[2]] }
        if object.is_a?(Array(String))
          name, method = object
          merge_same_key(result, name, method, value.first)
        end
      end
      params.reject {|k,v| k =~/\w*\[\w*\]/ || k == ""}
            .each do |key, value|
        merge_same_key(result, key, value.first, "true")
      end
      result
    end

    private def merge_same_key(result, name, method, value)
      if result[name]?
        result[name].merge!({method => value})
      else
        result.merge!({name => {method => value}})
      end
    end

  end
end
