require "mime"

module Amatista
  # Helpers used by the methods in the controller class.
  module Helpers

    # Redirects to an url
    #
    # Example
    # ```crystal
    # redirect_to "/tasks"
    # ```
    def redirect_to(path)
      HTTP::Response.new 303, "redirection", HTTP::Headers{"Location": path}
    end

    # Makes a respond based on context type
    # The body argument should be string if used html context type
    def respond_to(context, body)
      context = Mime.from_ext(context).to_s
      HTTP::Response.new(200, body, process_header(context))
    end

    private def process_header(context)
      header = HTTP::Headers.new
      header.add("Content-Type", context)
      if !$amatista.sessions.empty? && !has_session?
        header.add("Set-Cookie", send_sessions_to_cookie)
      end
      header
    end

    # Find out the IP address
    def remote_ip
      return unless request = $amatista.request

      headers = %w(X-Forwarded-For Proxy-Client-IP WL-Proxy-Client-IP HTTP_X_FORWARDED_FOR HTTP_X_FORWARDED
      HTTP_X_CLUSTER_CLIENT_IP HTTP_CLIENT_IP HTTP_FORWARDED_FOR HTTP_FORWARDED HTTP_VIA
      REMOTE_ADDR)

      headers.map{|header| request.headers[header]? as String | Nil}.compact.first
    end
  end
end
