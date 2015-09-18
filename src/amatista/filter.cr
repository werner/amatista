module Amatista
  #Callback filters to use before the actions.
  class Filter
    property block
    property paths
    property controller
    property condition

    def initialize(@controller, @paths, @condition, @block : T)
    end

    # Finds the filters based on the controller or the ApplicationController father
    # and the paths selected.
    def self.find_all(filters, controller, path)
      filters.select do |filter| 
        check_controller(filter.controller, controller) &&
          (filter.paths.includes?(path) || filter.paths.empty?)
      end
    end

    # This will search for the filters callbacks and execute the block
    #if it's not an HTTP::Response
    def self.execute_blocks(filters, controller, path)
      filters.each do |filter|
        if check_controller(filter.controller, controller) &&
            (filter.paths.includes?(path) || filter.paths.empty?) &&
            !filter.block.is_a?(-> HTTP::Response)
          filter.block.call()
        end
      end
    end

    #Find a filter that has a block as an HTTP::Response return's value
    def self.find_response(filters, controller, path)
      filters.each do |filter|
        block = filter.block
        if check_controller(filter.controller, controller) &&
            (filter.paths.includes?(path) || filter.paths.empty?) &&
            (filter.block.is_a?(-> HTTP::Response) && filter.condition.call())
          return block
        end
      end
    end

    private def self.check_controller(filter_controller, controller)
      (filter_controller == controller || 
        filter_controller == controller.try(&.superclass)) 
    end

  end
end
