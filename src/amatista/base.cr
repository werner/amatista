require "./helpers"
require "./sessions"

module Amatista
  # This class is used as a base for running amatista apps.
  class Base
    include Helpers
    include Sessions

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
      configuration = {} of Symbol => (String | Bool)
      yield(configuration)
      $amatista.secret_key          = configuration[:secret_key]?.to_s
      $amatista.database_connection = configuration[:database_connection]?.to_s
      $amatista.database_driver     = configuration[:database_driver]?.to_s
      public_dir                    = configuration[:public_dir]?.to_s
      $amatista.public_dir          = public_dir unless public_dir.empty?
      @@logs                        = configuration[:logs]? || false
    end

    # Run the server, just needs a port number.
    def run(port, environment = :development)
      $amatista.environment = environment
      server = create_server(port)
      server.listen
    end

    def run_forked(port, environment = :development, workers = 8)
      $amatista.environment = environment
      server = create_server(port)
      server.listen_fork(workers)
    end

    # Process static file
    def process_static(path)
      file = File.join($amatista.public_dir, path)
      if File.file?(file)
        if $amatista.environment == :production
          add_cache_control 
          add_last_modified(file)
        end
        respond_to(File.extname(path).gsub(".", ""), File.read(file))
      end
    end

    # Returns a response based on the request client.
    def process_request(request : HTTP::Request) : HTTP::Response
      begin
        response = Response.new(request)
        $amatista.request = request
        route = Response.find_route($amatista.routes, request.method, request.path.to_s)
        return HTTP::Response.not_found unless route

        response_filter = Filter.find_response($amatista.filters, route.controller, route.path)
        return response_filter.try &.call() if response_filter.is_a?(-> HTTP::Response) 

        Filter.execute_blocks($amatista.filters, route.controller, route.path)

        $amatista.params  = response.process_params(route)
        route.block.call($amatista.params)
      rescue e
        HTTP::Response.error "text/plain", "Error: #{e}"
      end
    end

    private def create_server(port)
      HTTP::Server.new port, do |request|
        p request if @@logs
        static_response = process_static(request.path.to_s)
        return static_response if static_response.is_a? HTTP::Response
        process_request(request)
      end
    end
  end
end
