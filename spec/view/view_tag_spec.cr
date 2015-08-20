require "../spec_helper"

describe ViewTag do
  context "#text_field" do
    it "display an input text" do
      view = BaseView.new

      view.text_field(:post, :title, { size: 20, class: "test_class" }).should(
        eq("<input type=\"text\" id=\"post_title\" name=\"post[title]\" size = \"20\" class = \"test_class\" />")
      )
      view.text_field(:post, :title).should eq("<input type=\"text\" id=\"post_title\" name=\"post[title]\" />")
    end

    it "display a hidden field" do
      view = BaseView.new

      view.hidden_tag(:post, :id, 1).should(
        eq("<input type=\"hidden\" id=\"post_id\" name=\"post[id]\" value=\"1\" />")
      )
    end

    it "display a submit button" do
      view = BaseView.new

      view.submit_tag.should eq("<input name=\"commit\" type=\"submit\" value=\"Save\" />")
    end

    it "display a form tag" do
      view = BaseView.new

      view.form_tag("/posts") do |form|
        form << view.text_field(:post, :title)
        form << view.text_field(:post, :name)
        form << view.submit_tag("Save changes")
      end.should eq("<form action=\"/posts\" method=\"post\">" +
                      "<input type=\"text\" id=\"post_title\" name=\"post[title]\" />" +
                      "<input type=\"text\" id=\"post_name\" name=\"post[name]\" />" +
                      "<input name=\"commit\" type=\"submit\" value=\"Save changes\" />" +
                    "</form>")
    end

    it "display a paragraph content tag" do
      view = BaseView.new

      view.content_tag(:p, "Hello world!").should eq("<p>Hello world!</p>")
    end

    it "display an input text inside a div content tag" do
      view = BaseView.new

      view.content_tag(:div, view.text_field(:post, :title), 
                       { class: "form-control" }).should(
                         eq("<div class = \"form-control\"><input type=\"text\" id=\"post_title\" name=\"post[title]\" /></div>")
                       )
    end

    it "display a link tag" do
      view = BaseView.new

      view.link_to("Profile", "/profiles/1").should eq("<a href=\"/profiles/1\">Profile</a>")
    end

    it "display a label tag" do
      view = BaseView.new

      view.label_tag("name", "Name").should eq("<label for=\"name\">Name</label>")
    end

    it "display a checkbox tag" do
      view = BaseView.new

      view.check_box_tag("task", "accept", "0", true).should(
        eq("<input type=\"checkbox\" id=\"task_accept\" name=\"task[accept]\" value =\"0\" checked =\"checked\" />")
      )
    end

    it "display a radio button tag" do
      view = BaseView.new

      view.radio_button_tag("task", "accept", "0", true).should(
        eq("<input type=\"radio\" id=\"task_accept\" name=\"task[accept]\" value =\"0\" checked =\"checked\" />")
      )
    end

    it "display a select tag" do
      view = BaseView.new

      view.select_tag("task", "countries", [["1", "USA"], ["2", "CANADA"], ["3", "VENEZUELA"]]).should(
        eq("<select id=\"task_countries\" name=\"task[countries]\" >" + 
             "<option value =\"1\">USA</option>" +
             "<option value =\"2\">CANADA</option>" +
             "<option value =\"3\">VENEZUELA</option>" +
           "</select>")
      )
    end
  end
end
