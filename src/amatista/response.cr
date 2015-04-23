class Amatista::Response
  property request

  def initialize(@request)
  end

  def find_action(actions)
    actions.find {|action_request| action_request.match_path?(@request.path.to_s) }
  end

  def process_static(path)
    if path.match(/.js|.css/)
      file = File.join(Dir.working_directory, path)
      Request.new("GET", path, 
                   ->(x : Hash(String, Array(String))){ File.read(file) }) if File.exists?(file)
    end
  end

  def process_params(action)
    action.request_path = @request.path.to_s
    action.add_params(CGI.parse(@request.body.to_s))
    action.get_params
  end

  def process_request(action, params, location)
    case action.method
    when "GET"
      HTTP::Response.ok "text/html", action.block.call(params)
    when "POST", "PUT", "DELETE", "PATCH"
      HTTP::Response.new 307, action.block.call(params), HTTP::Headers{"Location": location}
    else
      raise "Path not Found"
    end
  end
end
