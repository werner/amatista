class Amatista::Response
  property request

  def initialize(@request)
  end

  def find_route(routes)
    routes.find {|route_request| route_request.match_path?(@request.path.to_s) }
  end

  def process_static(path)
    if path.match(/.js|.css/)
      file = File.join(Dir.working_directory, path)
      Request.new("GET", path, 
                   ->(x : Hash(String, Array(String))){ File.read(file) }) if File.exists?(file)
    end
  end

  def process_params(route)
    route.request_path = @request.path.to_s
    route.add_params(CGI.parse(@request.body.to_s))
    route.get_params
  end

  def process_request(route, params, location)
    case route.method
    when "GET"
      HTTP::Response.ok "text/html", route.block.call(params)
    when "POST", "PUT", "DELETE", "PATCH"
      HTTP::Response.new 307, route.block.call(params), HTTP::Headers{"Location": location}
    else
      raise "Path not Found"
    end
  end
end
