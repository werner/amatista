require "http/server"
require "./route"

module Amatista
  # Use to saves configuration, routes and other data needed for the application.
  class Handler
    alias ParamsValue = Hash(String, String | Array(String)) | String | Array(String)
    alias Params      = Hash(String, ParamsValue)
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
    property flash
    property environment

    def initialize
      @params              = {} of String => ParamsValue
      @routes              = [] of Route
      @filters             = [] of Filter
      @sessions            = {} of String => Hash(String, String)
      @cookie_hash         = ""
      @secret_key          = ""
      @request             = nil
      @database_connection = ""
      @database_driver     = ""
      @public_dir          = Dir.working_directory
      @flash               = {} of Symbol => String
      @environment         = :development
    end
  end
end

$amatista = Amatista::Handler.new
