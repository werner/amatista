require "cgi"
require "http/server"
require "./route"

module Amatista
  class Handler
    property params
    property routes

    def initialize
      @params   = {} of String => Array(String)
      @routes  = [] of Route
    end
  end
end

$amatista = Amatista::Handler.new
