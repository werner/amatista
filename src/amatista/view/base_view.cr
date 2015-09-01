require "ecr"
require "ecr/macros"
require "./view_tag"
require "../sessions"

module Amatista
  # Set of methods to reduce the steps to display a view
  # It needs a LayoutView class that works as a layout view.
  # The views should be placed in app/views folder.
  class BaseView
    include ViewTag
    include Sessions

    def initialize(@arguments = nil)
    end

    # compiles the view with data in a string format
    def set_view
      LayoutView.new(self.to_s).to_s.strip
    end

    macro set_ecr(view_name, path = "src/views")
      if File.directory?({{path}})
        ecr_file "#{{{path}}}/#{{{view_name}}}.ecr"
      end
    end
  end
end
