require "./spec_helper"

class TestProcessController < Controller
  get("tests") { respond_to(:text, "Hello Tests") }
end

describe Base do
  app = Base.new
  headers = HTTP::Headers.new
  headers["Host"] = "host.domain.com"
  headers["Body"] = ""

  context "#process_request" do
    it "receive an http request" do
      request = HTTP::Request.new "GET", "/", headers

      response = app.process_request(request)

      response.class.should eq(HTTP::Response)
    end

    it "process a route with no slashes" do
      request = HTTP::Request.new "GET", "/tests", headers

      response = app.process_request(request)

      response.status_code.should eq(200)
    end
  end

  context "#process_static" do
    it "process a js file" do
      request = HTTP::Request.new "GET", "/", headers

      filename = "jquery.js"
      File.open(filename, "w") { |f| f.puts "jquery" }

      content = app.process_static("jquery.js")

      content.body.should eq("jquery\n") if content

      File.delete(filename)
    end

    it "does not process file" do
      request  = HTTP::Request.new "GET", "/", headers
      route    = app.process_static("jquery.js")

      route.should be_nil
    end

    it "process a path and returns nil" do
      request  = HTTP::Request.new "GET", "/", headers
      route    = app.process_static("/")

      route.should be_nil
    end

    it "generates a cached respond" do
      $amatista.environment = :production
      filename = "jquery.js"
      File.open(filename, "w") { |f| f.puts "jquery" }
      response = app.process_static("jquery.js")
      response.headers["Cache-control"].should_not be_nil if response.is_a? HTTP::Response
      File.delete(filename)
    end
  end

end
