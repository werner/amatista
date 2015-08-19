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

    it "display a form tag" do
      view = BaseView.new

      view.form_tag("/posts", "post") do |form|
        form << view.text_field(:post, :title)
        form << view.text_field(:post, :name)
      end.should eq("<form action=\"/posts\" method=\"post\">" +
                      "<input type=\"text\" id=\"post_title\" name=\"post[title]\" />" +
                      "<input type=\"text\" id=\"post_name\" name=\"post[name]\" />" +
                    "</form>")
    end
  end
end
