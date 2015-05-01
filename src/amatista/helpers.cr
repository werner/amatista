module Amatista
  module Helpers

    def redirect_to(path)
      route = Response.find_route(@routes, "GET", path)
      raise "#{path} not found" unless route
      HTTP::Response.new 303, "redirection", HTTP::Headers{"Location": path}
    end

    def respond_to(context, body)
      context = case context
                when :html then "text/html"
                when :json then "text/json"
                else
                  raise "#{context} not available"
                end

      HTTP::Response.ok context, body
    end
  end
end
