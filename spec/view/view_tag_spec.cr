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
  end
end
