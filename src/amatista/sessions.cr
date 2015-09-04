require "secure_random"

module Amatista
  # Methods to save a sessions hash in a cookie.
  module Sessions

    def send_sessions_to_cookie
      return "" unless request = $amatista.request
      hash = SecureRandom.base64
      $amatista.cookie_hash = $amatista.sessions[hash]? ? hash : SecureRandom.base64 
      "_amatista_session_id= #{$amatista.cookie_hash}"
    end

    # Saves a session key.
    def set_session(key, value)
      $amatista.cookie_hash = $amatista.cookie_hash.empty? ? get_cookie.to_s : $amatista.cookie_hash
      $amatista.sessions[$amatista.cookie_hash] = {key => value}
    end

    # Get a value from the cookie.
    def get_session(key)
      session_hash = get_cookie
      return nil unless $amatista.sessions[session_hash]?
      $amatista.sessions[session_hash][key]? if session_hash
    end

    # remove a sessions value from the cookie.
    def remove_session(key)
      session_hash = get_cookie
      return nil unless $amatista.sessions[session_hash]?
      $amatista.sessions[session_hash].delete(key)
    end

    def has_session?
      return unless request = $amatista.request
      cookie = request.headers["Cookie"]?.to_s
      !cookie.split(";").select(&.match(/_amatista_session_id/)).empty?
    end

    private def get_cookie
      return unless request = $amatista.request
      cookie = request.headers["Cookie"]?.to_s
      process_session(cookie)
    end

    private def process_session(string)
      amatista_session = string.split(";").select(&.match(/_amatista_session_id/)).first?
      amatista_session.gsub(/_amatista_session_id=/,"").gsub(/\s/,"") if amatista_session
    end
  end
end
