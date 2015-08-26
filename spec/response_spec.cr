require "webmock"
require "./spec_helper"

describe Response do
  context ".find_route" do
    it "find path /tasks/new from a group of routes" do
      WebMock.stub(:any, "test")
      response = HTTP::Client.get("http://test")
      routes = [Route.new(nil, "GET", "/tasks/new", ->(x : Hash(String, Array(String))){ response })]
      50.times do |n|
        routes <<  Route.new(nil, "GET", "/tasks/#{n}", ->(x : Hash(String, Array(String))){ response })
      end

      route = Response.find_route(routes, "GET", "/tasks/new")

      route.path.should eq("/tasks/new") if route
    end

    it "does not find path" do
      WebMock.stub(:any, "test")
      response = HTTP::Client.get("http://test")
      routes = [Route.new(nil, "GET", "/tasks/new", ->(x : Hash(String, Array(String))){ response })]
      50.times do |n|
        routes <<  Route.new(nil, "GET", "/tasks/#{n}", ->(x : Hash(String, Array(String))){ response })
      end

      route = Response.find_route(routes, "GET", "/tasks/edit")

      route.should be_nil
    end

    it "find the GET method route" do
      WebMock.stub(:any, "test")
      response = HTTP::Client.get("http://test")
      routes = [Route.new(nil, "GET", "/tasks", ->(x : Hash(String, Array(String))){ response }), 
                Route.new(nil, "PUT", "/tasks", ->(x : Hash(String, Array(String))){ response }),
                Route.new(nil, "POST", "/tasks", ->(x : Hash(String, Array(String))){ response })]


      route = Response.find_route(routes, "GET", "/tasks")

      if route
        route.method.should eq("GET")
        route.path.should eq("/tasks")
      end
    end

    it "find the POST method route" do
      WebMock.stub(:any, "test")
      response = HTTP::Client.get("http://test")
      routes = [Route.new(nil, "GET", "/tasks", ->(x : Hash(String, Array(String))){ response }), 
                Route.new(nil, "POST", "/tasks", ->(x : Hash(String, Array(String))){ response }),
                Route.new(nil, "DELETE", "/tasks", ->(x : Hash(String, Array(String))){ response })]

      route = Response.find_route(routes, "POST", "/tasks")

      if route
        route.method.should eq("POST")
        route.path.should eq("/tasks")
      end
    end
  end

  context "#process_static" do
    it "process a js file" do
      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = ""

      request = HTTP::Request.new "GET", "/", headers

      response = Response.new(request)

      filename = "jquery.js"
      File.open("jquery.js", "w") { |f| f.puts "jquery" }

      content = response.process_static("jquery.js")

      content.body.should eq("jquery\n") if content

      File.delete(filename)
    end

    it "does not process file" do
      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = ""

      request  = HTTP::Request.new "GET", "/", headers
      response = Response.new(request)
      route    = response.process_static("jquery.js")

      route.should be_nil
    end

    it "process a path and returns nil" do
      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = ""

      request  = HTTP::Request.new "GET", "/", headers
      response = Response.new(request)
      route    = response.process_static("/")

      route.should be_nil
    end
  end

  context "#process_params" do
      WebMock.stub(:any, "test")
      http_response = HTTP::Client.get("http://test")
      headers = HTTP::Headers.new
      headers["Host"] = "host.domain.com"
      headers["Body"] = ""

      request  = HTTP::Request.new "GET", "/tasks/edit/2/soon/34", headers
      response = Response.new(request)
      route    = Route.new(nil, "GET", 
                           "/tasks/edit/:id/soon/:other_task", 
                           ->(x : Hash(String, Array(String))){ http_response })
      route.request_path = "/tasks/edit/2/soon/34"

      response.process_params(route).should eq({"" => [""], "id" => ["2"], "other_task" => ["34"]})
  end
end
