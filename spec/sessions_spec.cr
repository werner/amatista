require "./spec_helper"

describe Sessions do
  app = Controller
  app.send_sessions_to_cookie

  $amatista.secret_key = "secret"
  headers = HTTP::Headers.new
  headers["Cookie"] = "_amatista_session_id=#{$amatista.cookie_hash};"
  $amatista.request = HTTP::Request.new "GET", "/", headers

  context "#set_session" do
    it "creates a session variable" do
      app.set_session("test", "testing a session variable")
      $amatista.sessions[$amatista.cookie_hash].should(
        eq({"test" => "testing a session variable"})
      )
    end
  end

  context "#get_session" do
    it "returns a session variable" do
      app.set_session("test", "testing a session variable")
      app.get_session("test").should eq("testing a session variable")
    end
  end

  context "#remove_session" do
    it "removes a session variable" do
      app.set_session("test", "testing a session variable")
      app.get_session("test").should eq("testing a session variable")
      app.remove_session("test")
      app.get_session("test").should eq(nil)
    end
  end

  context "#has_session?" do
    it "returns true if session variable exists" do
      app.has_session?.should eq(true)
    end
  end
end
