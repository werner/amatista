module Amatista
  class Filter
    property block
    property paths
    property controller

    def initialize(@controller, @paths, @block)
    end

    def self.find(filters, controller, path)
      filters.select {|filter| filter.controller == controller &&
                               (filter.paths.includes?(path) || filter.paths.empty?)}
    end
  end
end
