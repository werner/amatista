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

class FlashView < BaseView
  def initialize()
  end

  set_ecr("flash", "spec/app/views")
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
  before_filter(condition: -> { !get_session("condition") }) { redirect_to("/filter_tasks")  }

  get("/filter_tests") { respond_to(:text, "Hello Home") }
  get("/filter_tasks") { respond_to(:text, "Hello Tasks") }
end

describe Controller do
  subject = TestController
    
  it "gets a get request" do
    html_result = "<html><body>Hello World</body></html>"
    subject.get("/") { subject.respond_to(:html, html_result) }.body.should(
      eq("<html><body>Hello World</body></html>")
    )
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
    subject.send_sessions_to_cookie

    headers = HTTP::Headers.new
    headers["Cookie"] = "_amatista_session_id=#{$amatista.cookie_hash};"
    it "sets a global filter" do
      $amatista.request = HTTP::Request.new "GET", "/", headers
      $amatista.secret_key = "secret"

      subject.get("/") { subject.respond_to(:text, "Hello World") }
      Base.new.process_request(HTTP::Request.new("GET", "/", headers))
      subject.get_session("test_filter").should eq("testing a filter")
      subject.get_session("test_filter_with_paths").should eq(nil)
    end

    it "sets a filter for certain paths" do
      $amatista.request = HTTP::Request.new "GET", "/tasks", headers
      $amatista.secret_key = "secret"

      subject.get("/tasks") { subject.respond_to(:text, "Hello Tasks") }
      Base.new.process_request(HTTP::Request.new("GET", "/tasks", headers))
      subject.get_session("test_filter_with_paths").should eq("testing a filter with paths")
    end

    it "redirects from the filter" do
      $amatista.request = HTTP::Request.new "GET", "/tasks", headers
      $amatista.secret_key = "secret"

      Base.new.process_request(HTTP::Request.new("GET", "/filter_tests", headers)).body.should(
        eq("redirection")
      )
    end

    it "does not redirects from the filter" do
      $amatista.request = HTTP::Request.new "GET", "/tasks", headers
      $amatista.secret_key = "secret"

      subject.set_session("condition", "true")
      Base.new.process_request(HTTP::Request.new("GET", "/filter_tests", headers)).body.should(
        eq("Hello Home")
      )
    end
  end

  context "flash" do
    it "shows the flash message" do
      subject.get("/with_flash_message") do
        subject.set_flash(:message, "hello message")
        subject.respond_to(:html, FlashView.new.set_view)
      end.body.should(eq("<html><body>hello message\n</body></html>"))
    end

    it "does not show the flash message" do
      subject.get("/without_flash_message") do
        subject.respond_to(:html, FlashView.new.set_view)
      end.body.should(eq("<html><body>\n</body></html>"))
    end
  end
end
