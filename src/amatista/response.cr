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

    def process_params(route) : Handler::Params
      route.request_path = @request.path.to_s
      route.add_params(objectify_params(CGI.parse(@request.body.to_s)))
      route.get_params
    end

    #Convert params get from CGI to a Crystal Hash object
    private def objectify_params(params) : Handler::Params
      result = {} of String => Handler::ParamsValue
      params.select {|k,v| k =~/\w*\[\w*\]/}
            .each do |key, value|
        object = key.match(/(\w*)\[(\w*)\]/) { |x| [x[1], x[2]] }
        if object.is_a?(Array(String))
          name, method = object
          final_value = value.count > 1 ? value : value.first
          merge_same_key(result, name, method, final_value, result[name]?)
        end
      end
      params.reject {|k,v| k =~/\w*\[\w*\]/ || k == ""}
            .each do |key, value|
        result.merge!({key => value.first})
      end
      result
    end

    private def merge_same_key(result, name, method, value : String | Array(String), 
                               child : Handler::ParamsValue | Nil)

      case child
      when Hash(String, String | Array(String))
        child.merge!({method => value})
      else
        result.merge!({name => {method => value}})
      end
    end

  end
end
