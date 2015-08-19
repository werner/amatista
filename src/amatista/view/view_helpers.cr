module Amatista
  module ViewHelpers
    def options_transfomed(options = [] of Hash(Symbol, String))
      options.map do |key, value|
        "#{key.to_s} = \"#{value}\""
      end.join(" ")
    end
  end
end
