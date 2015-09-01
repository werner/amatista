module Amatista
  # This class is used as a base for running amatista apps.
  class Base

    # Saves the configure options in a global variable
    #
    # Example:
    # ```crystal
    # class Main < Amatista::Base
    #   configure do |conf|
    #     conf[:secret_key]          = "secret"
    #     conf[:database_driver]     = "postgres"
    #     conf[:database_connection] = ENV["DATABASE_URL"]
    #   end
    # end
    # ```
    def self.configure
      configuration = {} of Symbol => String
      yield(configuration)
      $amatista.secret_key          = configuration[:secret_key]? || ""
      $amatista.database_connection = configuration[:database_connection]? || ""
      $amatista.database_driver     = configuration[:database_driver]? || ""
      $amatista.public_dir          = configuration[:public_dir]? || $amatista.public_dir
      $amatista.logs                = configuration[:logs]? || false
    end

    # Run the server, just needs a port number.
    def run(port)
      server = HTTP::Server.new port, do |request|
        p request if $amatista.logs
        static_response = process_static(request.path.to_s)
        return static_response if static_response.is_a? HTTP::Response
        process_request(request)
      end
      server.listen
    end

    # Process static file
    def process_static(path)
      mime_type = Mime.from_ext(File.extname(path).gsub(".", ""))
      file      = File.join($amatista.public_dir, path)
      if File.exists?(file) && mime_type
        HTTP::Response.ok(mime_type.to_s, File.read(file))
      end
    end

    # Returns a response based on the request client.
    def process_request(request : HTTP::Request) : HTTP::Response
      begin
        response = Response.new(request)

        route = Response.find_route($amatista.routes, request.method, request.path.to_s)

        return HTTP::Response.not_found unless route

        filter = process_filter(route)
        return filter.call() if filter.is_a?(-> HTTP::Response)

        $amatista.params  = response.process_params(route)
        $amatista.request = request

        route.block.call($amatista.params)
      rescue e
        HTTP::Response.error "text/plain", "Error: #{e}"
      end
    end

    def process_filter(route) : (Nil | (-> HTTP::Response))
      filters = Filter.find($amatista.filters, route.controller, route.path)
      response_block = nil
      filters.each do |filter|
        block = filter.block
        if block.is_a?(-> HTTP::Response) && filter.condition.call()
          response_block = block
        else
          block.call()
        end
      end
      response_block
    end
  end
end
