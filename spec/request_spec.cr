require "./spec_helper"

describe Request do
  context "#match_path?" do
    it "match the root path to true" do
      request = Amatista::Request.new("GET", "/", -> {} )

      request.match_path?("/").should eq(true)
    end
  
    it "match /tasks/edit/:id with /tasks/edit/2 equal to true" do
      request = Amatista::Request.new("GET", "/tasks/edit/:id", -> {} )

      request.match_path?("/tasks/edit/2").should eq(true)
    end

    it "match /tasks/edit/:id with /tasks/edit/2/ equal to true" do
      request = Amatista::Request.new("GET", "/tasks/edit/:id", -> {} )

      request.match_path?("/tasks/edit/2/").should eq(true)
    end

    it "does not match /tasks/edit/:id with /tasks/edit/2 equal to true" do
      request = Amatista::Request.new("GET", "/tasks/edit/:id", -> {} )

      request.match_path?("/tasks/edit/2/show").should eq(false)
    end

  end
end
