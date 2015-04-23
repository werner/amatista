class Amatista::Response

  def process_request(request, actions)
    return if process_static(request.path.to_s)

    actions.find {|action_request| action_request.match_path?(request.path.to_s) }
  end

  def process_static(path)
    if path.match(/.js|.css/)
      file = File.join(Dir.working_directory, path)
      Request.new("GET", path, 
                   ->(x : Hash(String, Array(String))){ File.read(file) }) if File.exists?(file)
    end
  end
end
