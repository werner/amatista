module Amatista
  #Callback filters to use before the actions.
  class Filter
    property block
    property paths
    property controller
    property condition

    def initialize(@controller, @paths, @condition, @block)
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
