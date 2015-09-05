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
      subject.add_last_modified("#{__DIR__}/app/views/flash.ecr")
      response = subject.respond_to(:text, "Hello Tests")
    end.headers["Last-modified"].should eq("2015-09-03 16:30:39 UTC")
  end

  it "sets etag" do
    subject.get("/tests") do
      subject.add_etag("#{__DIR__}/app/views/flash.ecr")
      response = subject.respond_to(:text, "Hello Tests")
    end.headers["etag"].should eq("c9258ab64a3d9b2b9ba99faff002a395")
  end
end
