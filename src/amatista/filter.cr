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
      filters.select do |filter| 
        check_controller(filter.controller, controller) &&
          (filter.paths.includes?(path) || filter.paths.empty?)
      end
    end

    private def self.check_controller(filter_controller, controller)
      (filter_controller == controller || 
        filter_controller == controller.try(&.superclass)) 
    end

  end
end
