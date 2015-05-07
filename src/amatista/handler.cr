require "cgi"
require "http/server"
require "./route"

module Amatista
  class Handler
    property params
    property routes
    property sessions
    property cookie_hash
    property secret_key
    property request
    property database_connection
    property database_driver

    def initialize
      @params              = {} of String => Array(String)
      @routes              = [] of Route
      @sessions            = {} of String => Hash(String, String)
      @cookie_hash         = ""
      @secret_key          = ""
      @request             = nil
      @database_connection = ""
      @database_driver     = ""
    end
  end
end

$amatista = Amatista::Handler.new
