module Amatista
  class Base

    def self.configure
      configuration = {} of Symbol => String
      yield(configuration)
      $amatista.secret_key          = configuration[:secret_key]? || ""
      $amatista.database_connection = configuration[:database_connection]? || ""
      $amatista.database_driver     = configuration[:database_driver]? || ""
      $amatista.public_dir          = configuration[:public_dir]? || Dir.working_directory
    end

    def run(port)
      server = HTTP::Server.new port, do |request|
        p request
        process(request)
      end
      server.listen
    end

    def process(request)
      begin
        response = Response.new(request)

        route = response.process_static(request.path.to_s)
        route = Response.find_route($amatista.routes, request.method, request.path.to_s) unless route

        return HTTP::Response.not_found unless route

        $amatista.params  = response.process_params(route)
        $amatista.request = request

        route.block.call($amatista.params)
      rescue e
        HTTP::Response.error "text/plain", "Error: #{e}"
      end
    end
  end
end
