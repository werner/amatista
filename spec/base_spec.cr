require "./spec_helper"

describe Base do
  it "gets a get request" do
    app = Base.new
    
    html_result = "<html><body>Hello World</body></html>"
    app.get("/") { app.respond_to(:html, html_result) }.body.should eq(html_result)
  end

  context "#process" do
    it "receive an http request" do
      app = Base.new

      html_result = "<html><body>Hello World</body></html>"
      app.get("/") { app.respond_to(:html, html_result) }

      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = nil

      request = HTTP::Request.new "GET", "/", headers

      response = app.process(request)

      response.class.should eq(HTTP::Response)
    end
  end

  context "redirect_to" do
    it "redirects to /" do
      app = Base.new
      html_result = "<html><body>Hello World</body></html>"
      app.get("/") { app.respond_to(:html, html_result) }

      response = app.redirect_to("/")

      response.status_code.should eq(303)
    end
  end

end
