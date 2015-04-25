require "./spec_helper"

describe Base do
  it "gets a get request" do
    app = Base.new
    
    html_result = "<html><body>Hello World</body></html>"
    app.get("/") { html_result }.should eq(html_result)
  end

  context "#process" do
    it "receive an http request" do
      app = Base.new

      html_result = "<html><body>Hello World</body></html>"
      app.get("/") { html_result }

      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = nil

      request = HTTP::Request.new "GET", "/", headers

      app.process(request).body.should eq("<html><body>Hello World</body></html>")
    end
  end
end
