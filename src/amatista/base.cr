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
    end

    # Run the server, just needs a port number
    def run(port)
      server = HTTP::Server.new port, do |request|
        p request
        process(request)
      end
      server.listen
    end

    # Returns a response based on the request client.
    def process(request : HTTP::Request ) : HTTP::Response
      begin
        response = Response.new(request)

        route = response.process_static(request.path.to_s) ||
                Response.find_route($amatista.routes, request.method, request.path.to_s)

        return HTTP::Response.not_found unless route
        return route if route.is_a? HTTP::Response

        $amatista.params  = response.process_params(route)
        $amatista.request = request

        filters = Filter.find($amatista.filters, route.controller, route.path)

        filters.each(&.block.call()) unless filters.empty?
        route.block.call($amatista.params)
      rescue e
        HTTP::Response.error "text/plain", "Error: #{e}"
      end
    end
  end
end
