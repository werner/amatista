require "./spec_helper"

describe Base do

  context "#process_request" do
    it "receive an http request" do
      app = Base.new

      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = ""

      request = HTTP::Request.new "GET", "/", headers

      response = app.process_request(request)

      response.class.should eq(HTTP::Response)
    end
  end

  context "#process_static" do
    it "process a js file" do
      app = Base.new

      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = ""

      request = HTTP::Request.new "GET", "/", headers

      filename = "jquery.js"
      File.open("jquery.js", "w") { |f| f.puts "jquery" }

      content = app.process_static("jquery.js")

      content.body.should eq("jquery\n") if content

      File.delete(filename)
    end

    it "does not process file" do
      app = Base.new

      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = ""

      request  = HTTP::Request.new "GET", "/", headers
      route    = app.process_static("jquery.js")

      route.should be_nil
    end

    it "process a path and returns nil" do
      app = Base.new

      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = ""

      request  = HTTP::Request.new "GET", "/", headers
      route    = app.process_static("/")

      route.should be_nil
    end
  end

end
