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

class ApplicationController < Controller
  before_filter { set_session("test_filter", "testing a filter")  }
  before_filter(["/tasks", "/users"]) { 
    set_session("test_filter_with_paths", "testing a filter with paths") 
  }
end

class TestController < ApplicationController
end

class FinishController < Controller
  before_filter { redirect_to("/filter_tasks")  }
end

describe Controller do
  subject = TestController
    
  it "gets a get request" do
    html_result = "<html><body>Hello World</body></html>"
    subject.get("/") { subject.respond_to(:html, html_result) }.body.should eq("<html><body>Hello World</body></html>")
  end

  it "gets a request based on a view" do
    subject.get("/") do
      tasks = ["first task", "second task"]
      subject.respond_to(:html, DataTestView.new(tasks).set_view) 
    end.body.should(eq(
      "<html><body><h1>Hello World Test</h1>" +
      "<table> tasks: [\"first task\", \"second task\"]</table>\n</body></html>"
    ))
  end

  context "filters" do
    it "sets a global filter" do
      headers = HTTP::Headers.new
      headers["Cookie"] = "_amatista_session_id=NWViZTIyOTRlY2QwZTBmMDhlYWI3NjkwZDJhNmVlNjk=;"

      $amatista.request = HTTP::Request.new "GET", "/", headers
      $amatista.secret_key = "secret"

      subject.get("/") { subject.respond_to(:text, "Hello World") }
      Base.new.process_request(HTTP::Request.new("GET", "/", headers))
      subject.get_session("test_filter").should eq("testing a filter")
      subject.get_session("test_filter_with_paths").should eq(nil)
    end

    it "sets a filter for certain paths" do
      headers = HTTP::Headers.new
      headers["Cookie"] = "_amatista_session_id=NWViZTIyOTRlY2QwZTBmMDhlYWI3NjkwZDJhNmVlNjk=;"

      $amatista.request = HTTP::Request.new "GET", "/tasks", headers
      $amatista.secret_key = "secret"

      subject.get("/tasks") { subject.respond_to(:text, "Hello Tasks") }
      Base.new.process_request(HTTP::Request.new("GET", "/tasks", headers))
      subject.get_session("test_filter_with_paths").should eq("testing a filter with paths")
    end

    pending "redirects from the filter" do
      headers = HTTP::Headers.new
      headers["Cookie"] = "_amatista_session_id=NWViZTIyOTRlY2QwZTBmMDhlYWI3NjkwZDJhNmVlNjk=;"

      $amatista.request = HTTP::Request.new "GET", "/tasks", headers
      $amatista.secret_key = "secret"

      subject = FinishController
      subject.get("/filter_tests") { subject.respond_to(:text, "Hello Home") }
      subject.get("/filter_tasks") { subject.respond_to(:text, "Hello Tasks") }
      Base.new.process_request(HTTP::Request.new("GET", "/filter_tests", headers)).body.should(
        eq("Hello Tasks")
      )
    end
  end
end
