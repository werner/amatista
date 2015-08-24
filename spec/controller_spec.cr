require "./spec_helper"

class LayoutView < BaseView
  def initialize(@container)
  end

  set_ecr("layout", "spec/app/views")
end

class DataTestView < BaseView
  def initialize(@tasks)
  end

  set_ecr("test_data", "spec/app/views")
end

describe Controller do
  it "gets a get request" do
    app = Controller
    
    html_result = "<html><body>Hello World</body></html>"
    app.get("/") { app.respond_to(:html, html_result) }.body.should eq("<html><body>Hello World</body></html>")
  end

  it "gets a request based on a view" do
    app = Controller

    app.get("/") do
      tasks = ["first task", "second task"]
      app.respond_to(:html, DataTestView.new(tasks).set_view) 
    end.body.should(eq(
      "<html><body><h1>Hello World Test</h1>" +
      "<table> tasks: [\"first task\", \"second task\"]</table>\n</body></html>"
    ))
  end
end
