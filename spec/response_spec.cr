require "webmock"
require "./spec_helper"

describe Response do
  WebMock.stub(:any, "test")
  @@response = HTTP::Client.get("http://test")

  context ".find_route" do
    it "find path /tasks/new from a group of routes" do
      routes = [Route.new(nil, "GET", "/tasks/new", 
                          ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response })]
      50.times do |n|
        routes <<  Route.new(nil, "GET", "/tasks/#{n}", 
                             ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response })
      end

      route = Response.find_route(routes, "GET", "/tasks/new")

      route.path.should eq("/tasks/new") if route
    end

    it "does not find path" do
      routes = [Route.new(nil, "GET", "/tasks/new", 
                          ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response })]
      50.times do |n|
        routes <<  Route.new(nil, "GET", "/tasks/#{n}", 
                             ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response })
      end

      route = Response.find_route(routes, "GET", "/tasks/edit")

      route.should be_nil
    end

    it "find the GET method route" do
      routes = [Route.new(nil, "GET", "/tasks", 
                          ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response }), 
                Route.new(nil, "PUT", "/tasks", 
                          ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response }),
                Route.new(nil, "POST", "/tasks", 
                          ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response })]


      route = Response.find_route(routes, "GET", "/tasks")

      if route
        route.method.should eq("GET")
        route.path.should eq("/tasks")
      end
    end

    it "find the POST method route" do
      routes = [Route.new(nil, "GET", "/tasks", 
                          ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response }), 
                Route.new(nil, "POST", "/tasks", 
                          ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response }),
                Route.new(nil, "DELETE", "/tasks", 
                          ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response })]

      route = Response.find_route(routes, "POST", "/tasks")

      if route
        route.method.should eq("POST")
        route.path.should eq("/tasks")
      end
    end
  end

  context "#process_params" do
    headers = HTTP::Headers.new
    headers["Host"] = "host.domain.com"
    it "process params from path" do
      headers["Body"] = ""

      request  = HTTP::Request.new "GET", "/tasks/edit/2/soon/34", headers
      response = Response.new(request)
      route    = Route.new(nil, "GET", 
                           "/tasks/edit/:id/soon/:other_task", 
                           ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response })
      route.request_path = "/tasks/edit/2/soon/34"

      response.process_params(route).should eq({"id" => "2", "other_task" => "34"})
    end

    it "process params from body request" do
      headers["Body"] = ""
      body = "task%5Bname%5D=hi&task%5Bdescription%5D=salute&commit=Create"
      request  = HTTP::Request.new "POST", "/tasks/create", headers, body
      response = Response.new(request)
      route    = Route.new(nil, "POST", 
                           "/tasks/create", 
                           ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response })
      route.request_path = "/tasks/create"

      response.process_params(route).should eq({"task" => {"name" => "hi", "description" => "salute"}, 
                                                "commit" => "Create"})
    end

    it "process params with checkboxes group from body request" do
      headers["Body"] = ""
      body = "task%5Bname%5D=hi&task%5Bdescription%5D=salute&task%5Btaxonomy_ids%5D=2&task%5Btaxonomy_ids%5D=3&commit=Create"
      request  = HTTP::Request.new "POST", "/tasks/create", headers, body
      response = Response.new(request)
      route    = Route.new(nil, "POST", 
                           "/tasks/create", 
                           ->(x : Hash(String, Hash(String, String | Array(String)) | String | Array(String))){ @@response })
      route.request_path = "/tasks/create"

      response.process_params(route).should eq({"task" => {"name" => "hi", 
                                                           "description" => "salute",
                                                           "taxonomy_ids" => ["2", "3"]}, 
                                                "commit" => "Create"})
    end
  end
end
