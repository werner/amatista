module Amatista
  module ViewHelpers
    def options_transfomed(options = [] of Hash(Symbol, String))
      options.map do |key, value|
        "#{key.to_s} = \"#{HTML.escape(value.to_s)}\""
      end.join(" ")
    end
  end
end
