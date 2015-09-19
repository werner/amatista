require "./flash"
require "./helpers"
require "./sessions"

module Amatista
  class Controller
    extend Helpers
    extend Sessions
    extend Flash

    macro inherited
      # Creates 5 methods to handle the http requests from the browser.
      {% for method in %w(get post put delete patch) %}
        def self.{{method.id}}(path : String, &block : Amatista::Handler::Params -> HTTP::Response)
          $amatista.routes << Amatista::Route.new({{@type}}, "{{method.id}}".upcase, path, block)
          yield($amatista.params)
        end
      {% end %}

      def self.before_filter(paths = [] of String, condition = -> { false }, &block : -> T)
        $amatista.filters << Amatista::Filter.new({{@type}}, paths, condition, block)
      end

      def self.superclass
        {{@type.superclass}}
      end
    end

    def self.superclass
      self
    end

  end
end
