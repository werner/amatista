require "../spec_helper"

class LayoutView < BaseView
  def initialize(@container)
  end

  set_ecr("layout", "spec/app/views")
end

class TestView < BaseView
  set_ecr("test", "spec/app/views")
end

describe BaseView do
  context "#view" do
    it "display a view file" do
      view = TestView

      view.new([1,2,3]).set_view.should eq("<html><body><h1>Hello World Test</h1>\n</body></html>")
    end
  end
end
