module Amatista
  module Helpers

    def redirect_to(path)
      route = Response.find_route($amatista.routes, "GET", path)
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
      HTTP::Response.new(200, body, process_header(context))
    end

    def process_header(context)
      header = HTTP::Headers.new
      header.add("Content-Type", context)
      if !$amatista.sessions.empty? && !has_session
        header.add("Set-Cookie", send_sessions_to_cookie)
      end
      header
    end

    def remote_ip
      return unless request = $amatista.request

      headers = %w(X-Forwarded-For Proxy-Client-IP WL-Proxy-Client-IP HTTP_X_FORWARDED_FOR HTTP_X_FORWARDED
      HTTP_X_CLUSTER_CLIENT_IP HTTP_CLIENT_IP HTTP_FORWARDED_FOR HTTP_FORWARDED HTTP_VIA
      REMOTE_ADDR)

      headers.select{|header| request.headers[header]?}.first
    end
  end
end
