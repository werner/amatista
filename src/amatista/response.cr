class Amatista::Response
  property request

  def initialize(@request)
  end

  def self.find_route(routes, path_to_find)
    routes.find {|route_request| route_request.match_path?(path_to_find) }
  end

  def process_static(path)
    content_type = "application/javascript" if path.match(/\.js/)
    content_type = "text/css" if path.match(/\.css/)
    return if content_type.nil?

    file = File.join(Dir.working_directory, path)
    Route.new("GET", path, 
               ->(x : Hash(String, Array(String))){ HTTP::Response.ok content_type, File.read(file) }) if File.exists?(file)
  end

  def process_params(route)
    route.request_path = @request.path.to_s
    route.add_params(CGI.parse(@request.body.to_s))
    route.get_params
  end
end
