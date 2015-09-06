require "./spec_helper"

class TestCacheController < Controller
end

describe Helpers do
  subject = TestCacheController

  it "sets cache control" do
    subject.get("/tests") do
      subject.add_cache_control
      response = subject.respond_to(:text, "Hello Tests")
    end.headers["Cache-control"].should eq("public, max-age=31536000")
  end

  it "sets last modified" do
    subject.get("/tests") do
      filename = "for_cache"
      File.open(filename, "w") { |f| f.puts "Today" }
      subject.add_last_modified(filename)
      File.delete(filename)
      response = subject.respond_to(:text, "Hello Tests")
    end.headers["Last-modified"].should match(/\d{4}-\d{2}-\d{2}.* UTC/)
  end

  it "sets etag" do
    subject.get("/tests") do
      filename = "for_cache"
      File.open(filename, "w") { |f| f.puts "Today" }
      subject.add_etag(filename)
      File.delete(filename)
      response = subject.respond_to(:text, "Hello Tests")
    end.headers["etag"].length.should eq(32)
  end
end
