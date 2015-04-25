class Amatista::Response
  property request

  def initialize(@request)
  end

  def self.find_route(routes, path_to_find)
    routes.find {|route_request| route_request.match_path?(path_to_find) }
  end

  def process_static(path)
    if path.match(/.js|.css/)
      file = File.join(Dir.working_directory, path)
      Route.new("GET", path, 
                 ->(x : Hash(String, Array(String))){ File.read(file) }) if File.exists?(file)
    end
  end

  def process_params(route)
    route.request_path = @request.path.to_s
    route.add_params(CGI.parse(@request.body.to_s))
    route.get_params
  end
end
