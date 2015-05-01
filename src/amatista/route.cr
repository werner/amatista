module Amatista
  class Route
    property method
    property path
    property block
    property request_path

    def initialize(@method, @path, @block)
      @params = {} of String => Array(String)
      @request_path = ""
    end

    # Get personalized params from routes defined by user
    def get_params
      if @params.empty? || @request_path == ""
        raise "You need to set params and request_path first"
      else
        extract_params_from_path
        @params
      end
    end

    # Search for similar paths
    # Ex. /tasks/edit/:id == /tasks/edit/2
    def match_path?(path)
      return path == "/" if @path == "/"

      original_path = @path.split("/")
      path_to_match = path.split("/")

      original_path.length == path_to_match.length &&
        original_path.zip(path_to_match).all? do |item|
          item[0].match(/(:\w*)/) ? true : item[0] == item[1] 
        end
    end

    # Add personalized params to the coming from requests
    def add_params(params)
      params.each do |key, value|
        @params[key] = value
      end
    end

    private def extract_params_from_path
      params = @path.to_s.scan(/(:\w*)/).map(&.[](0))
      pairs  = @path.split("/").zip(@request_path.split("/"))
      pairs.select{|pair| params.includes?(pair[0])}.each do |p|
        @params[p[0].gsub(/:/, "")] = [p[1]]
      end
    end
  end
end
