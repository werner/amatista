require "../spec_helper"

class LayoutView < BaseView
  def initialize(@container)
  end

  set_ecr("layout", "app/views")
end

class TestView < BaseView
  set_ecr("test", "app/views")
end

describe BaseView do
  context "#view" do
    it "display a view file" do
      view = TestView

      view.new([1,2,3]).set_view.should eq("<html><body><h1>Hello World Test</h1>\n</body></html>")
    end
  end
end
