module Amatista
  class Filter
    property block
    property paths
    property controller

    def initialize(@controller, @paths, @block)
    end

    # Finds the filters based on the controller or the ApplicationController father
    # and the paths selected.
    def self.find(filters, controller, path)
      filters.select {|filter| (filter.controller == controller || 
                                filter.controller == controller.try(&.superclass)) &&
                               (filter.paths.includes?(path) || filter.paths.empty?)}
    end

  end
end
