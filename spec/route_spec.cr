require "webmock"
require "./spec_helper"

describe Route do
  WebMock.stub(:any, "test")
  @@response = HTTP::Client.get("http://test")

  context "#match_path?" do
    it "match the root path to true" do
      route = Route.new(nil, "GET", "/", ->(params : Handler::Params) { @@response })

      route.match_path?("/").should eq(true)
    end
  
    it "match /tasks/edit/:id with /tasks/edit/2" do
      route = Route.new(nil, "GET", "/tasks/edit/:id", ->(params : Handler::Params) { @@response })

      route.match_path?("/tasks/edit/2").should eq(true)
    end

    it "match /tasks/edit/:id with /tasks/edit/2/" do
      route = Route.new(nil, "GET", "/tasks/edit/:id", ->(params : Handler::Params) { @@response })

      route.match_path?("/tasks/edit/2/").should eq(true)
    end

    it "does not match /tasks/edit/:id with /tasks/edit/2" do
      route = Route.new(nil, "GET", "/tasks/edit/:id", ->(params : Handler::Params) { @@response })

      route.match_path?("/tasks/edit/2/show").should eq(false)
    end
  end

  context "#get_params" do
    it "extracts params from /tasks/edit/:id" do
      route = Route.new(nil, "GET", "/tasks/edit/:id", ->(params : Handler::Params) { @@response })

      route.request_path = "/tasks/edit/2"
      params = {} of String => Handler::ParamsValue
      params = {"task" => {"description" => "some description", "taxonomy_ids" => ["1", "2"]}}
      route.add_params(params)

      route.get_params.should eq({"task" => {"description" => "some description", 
                                             "taxonomy_ids" => ["1", "2"]}, "id" => "2"})
    end
  end
end
