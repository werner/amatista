require "./spec_helper"

describe Base do

  context "#process" do
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

end
