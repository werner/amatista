module Amatista
  class Filter
    property block
    property paths

    def initialize(@controller, @paths, @block)
    end
  end
end
