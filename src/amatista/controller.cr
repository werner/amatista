require "./helpers"

module Amatista
  class Controller
    extend Helpers

    {% for method in %w(get post put delete patch) %}
      def self.{{method.id}}(path, &block : Hash(String, Array(String)) -> HTTP::Response)
        $amatista.routes << Route.new("{{method.id}}".upcase, path.to_s, block)
        yield($amatista.params)
      end
    {% end %}
  end
end
