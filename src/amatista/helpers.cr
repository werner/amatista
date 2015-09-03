require "http/server"
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
      add_headers({location: path})
      HTTP::Response.new 303, "redirection", set_headers
    end

    # Makes a respond based on context type
    # The body argument should be string if used html context type
    def respond_to(context, body)
      context = Mime.from_ext(context).to_s
      add_headers({context: context})
      HTTP::Response.new 200, body, set_headers
    end

    def add_headers(headers = {} of Symbol => String)
      @@header = HTTP::Headers.new unless @@header
    
      header = @@header
      if header
        headers.map do |type, value|
          case type
          when :context
            header.add("Content-Type", value)
          when :location
            header.add("Location", value)
          when :cache
            header.add("Cache-Control", value)
          end
        end
        if !$amatista.sessions.empty? && !has_session?
          header.add("Set-Cookie", send_sessions_to_cookie)
        end
      end
      @@header = header
    end

    def set_headers
      headers = @@header
      @@header = HTTP::Headers.new
      headers || HTTP::Headers.new
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
