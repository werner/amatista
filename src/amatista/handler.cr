require "cgi"
require "http/server"
require "./route"

module Amatista
  # Use to saves configuration, routes and other data needed for the application. 
  class Handler
    property params
    property routes
    property filters
    property sessions
    property cookie_hash
    property secret_key
    property request
    property database_connection
    property database_driver
    property public_dir

    def initialize
      @params              = {} of String => Array(String)
      @routes              = [] of Route
      @filters             = [] of Filter
      @sessions            = {} of String => Hash(String, String)
      @cookie_hash         = ""
      @secret_key          = ""
      @request             = nil
      @database_connection = ""
      @database_driver     = ""
      @public_dir          = Dir.working_directory
    end
  end
end

$amatista = Amatista::Handler.new
