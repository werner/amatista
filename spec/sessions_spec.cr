require "./spec_helper"

describe Sessions do
  context "#set_session" do
    it "creates a session variable" do
      app = Controller

      $amatista.secret_key = "secret"

      app.set_session("test", "testing a session variable")
      $amatista.cookie_hash.should eq "NWViZTIyOTRlY2QwZTBmMDhlYWI3NjkwZDJhNmVlNjk="
      $amatista.sessions["NWViZTIyOTRlY2QwZTBmMDhlYWI3NjkwZDJhNmVlNjk="].should(
        eq({"test" => "testing a session variable"})
      )
    end
  end

  context "#get_session" do
    it "returns a session variable" do
      headers = HTTP::Headers.new
      headers["Cookie"] = "_amatista_session_id=NWViZTIyOTRlY2QwZTBmMDhlYWI3NjkwZDJhNmVlNjk=;"

      app = Controller

      $amatista.request = HTTP::Request.new "GET", "/", headers
      $amatista.secret_key = "secret"

      app.set_session("test", "testing a session variable")
      app.get_session("test").should eq("testing a session variable")
    end
  end

  context "#remove_session" do
    it "removes a session variable" do
      headers = HTTP::Headers.new
      headers["Cookie"] = "_amatista_session_id=NWViZTIyOTRlY2QwZTBmMDhlYWI3NjkwZDJhNmVlNjk=;"

      app = Controller

      $amatista.request = HTTP::Request.new "GET", "/", headers
      $amatista.secret_key = "secret"

      app.set_session("test", "testing a session variable")
      app.get_session("test").should eq("testing a session variable")
      app.remove_session("test")
      app.get_session("test").should eq(nil)
    end
  end

  context "#has_session?" do
    it "returns true if session variable exists" do
      headers = HTTP::Headers.new
      headers["Cookie"] = "_amatista_session_id=NWViZTIyOTRlY2QwZTBmMDhlYWI3NjkwZDJhNmVlNjk=;"

      app = Controller

      $amatista.request = HTTP::Request.new "GET", "/", headers
      app.has_session?.should eq(true)
    end
  end
end
