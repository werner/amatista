require "./spec_helper"

describe Controller do
  it "gets a get request" do
    app = Controller
    
    html_result = "<html><body>Hello World</body></html>"
    app.get("/") { app.respond_to(:html, html_result) }.body.should eq("<html><body>Hello World</body></html>")
  end
end
