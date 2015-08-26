require "webmock"
require "./spec_helper"

describe Route do
  context "#match_path?" do
    it "match the root path to true" do
      WebMock.stub(:any, "test")
      response = HTTP::Client.get("http://test")
      route = Route.new(nil, "GET", "/", ->(params : Hash(String, Array(String))) { response })

      route.match_path?("/").should eq(true)
    end
  
    it "match /tasks/edit/:id with /tasks/edit/2" do
      WebMock.stub(:any, "test")
      response = HTTP::Client.get("http://test")
      route = Route.new(nil, "GET", "/tasks/edit/:id", 
                        ->(params : Hash(String, Array(String))) { response })

      route.match_path?("/tasks/edit/2").should eq(true)
    end

    it "match /tasks/edit/:id with /tasks/edit/2/" do
      WebMock.stub(:any, "test")
      response = HTTP::Client.get("http://test")
      route = Route.new(nil, "GET", "/tasks/edit/:id", 
                        ->(params : Hash(String, Array(String))) { response })

      route.match_path?("/tasks/edit/2/").should eq(true)
    end

    it "does not match /tasks/edit/:id with /tasks/edit/2" do
      WebMock.stub(:any, "test")
      response = HTTP::Client.get("http://test")
      route = Route.new(nil, "GET", "/tasks/edit/:id", 
                        ->(params : Hash(String, Array(String))) { response })

      route.match_path?("/tasks/edit/2/show").should eq(false)
    end
  end

  context "#get_params" do
    it "extracts params from /tasks/edit/:id" do
      WebMock.stub(:any, "test")
      response = HTTP::Client.get("http://test")
      route = Route.new(nil, "GET", "/tasks/edit/:id", 
                        ->(params : Hash(String, Array(String))) { response })

      route.request_path = "/tasks/edit/2"
      route.add_params({"description" => ["some description"]})

      route.get_params.should eq({"description" => ["some description"], "id" => ["2"]})
    end
  end
end
