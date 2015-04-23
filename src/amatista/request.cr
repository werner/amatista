class Amatista::Request < HTTP::Request
  property block
  property request_path

  def initialize(@method, @path, @block)
    @params = {} of String => Array(String)
    @request_path = ""
    super(@method, @path, HTTP::Headers.new)
  end

  # Get personalized params from routes defined by user
  def get_params
    extract_params_from_path
    @params
  end

  # Search for similar paths
  # Ex. /tasks/edit/:id == /tasks/edit/2
  def match_path?(path)
    return path == "/" if @path == "/"

    route_to_match = Regex.new(@path.to_s.gsub(/(:\w*)/, ".*"))
    path.match(route_to_match)
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
