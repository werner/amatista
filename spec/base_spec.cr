require "./spec_helper"

describe Base do
  it "gets a get request" do
    app = Amatista::Base.new
    
    html_result = "<html><body>Hello World</body></html>"
    app.get("/") { html_result }.should eq(html_result)
    
  end
end
