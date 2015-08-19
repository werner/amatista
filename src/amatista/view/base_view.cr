require "ecr"
require "ecr/macros"
require "./view_tag"

module Amatista
  class BaseView
    include ViewTag

    def initialize(@arguments = nil)
    end

    def set_view
      LayoutView.new(self.to_s).to_s.strip
    end

    macro set_ecr(view_name)
      ecr_file "app/views/#{{{view_name}}}.ecr"
    end
  end
end
