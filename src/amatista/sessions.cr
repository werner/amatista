require "base64"
require "crypto/md5"

module Amatista
  # Methods to save a sessions hash in a cookie.
  module Sessions

    def send_sessions_to_cookie
      return "" unless request = $amatista.request
      "_amatista_session_id= #{$amatista.cookie_hash}"
    end

    # Saves a session key.
    def set_session(key, value)
      $amatista.cookie_hash = Base64.strict_encode64(Crypto::MD5.hex_digest($amatista.secret_key))
      $amatista.sessions[$amatista.cookie_hash] = {key => value}
    end

    # Get a value from the cookie.
    def get_session(key)
      return unless request = $amatista.request
      cookie = request.headers["Cookie"]?.to_s
      session_hash = process_session(cookie)
      $amatista.sessions[session_hash][key]?
    end

    def has_session
      return unless request = $amatista.request
      cookie = request.headers["Cookie"]?.to_s
      !cookie.split(";").select(&.match(/_amatista_session_id/)).empty?
    end

    private def process_session(string)
      string.split(";").select(&.match(/_amatista_session_id/)).first.gsub(/_amatista_session_id=/,"").gsub(/\s/,"")
    end
  end
end
