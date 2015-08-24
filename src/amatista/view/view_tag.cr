require "./view_helpers"

module Amatista
  # Methods to create html tags using crystal
  module ViewTag
    include ViewHelpers
    
    def text_field(object_name, method, raw_options = [] of Hash(Symbol, String))
      input_tag(raw_options) do |str_result|
        str_result << "<input type=\"text\" id=\"#{HTML.escape(object_name.to_s)}_#{HTML.escape(method.to_s)}\" "
        str_result << "name=\"#{HTML.escape(object_name.to_s)}[#{HTML.escape(method.to_s)}]\""
      end
    end

    def password_field(object_name, method, raw_options = [] of Hash(Symbol, String))
      input_tag(raw_options) do |str_result|
        str_result << "<input type=\"password\" id=\"#{HTML.escape(object_name.to_s)}_#{HTML.escape(method.to_s)}\" "
        str_result << "name=\"#{HTML.escape(object_name.to_s)}[#{HTML.escape(method.to_s)}]\""
      end
    end

    def hidden_tag(object_name, method, value, raw_options = [] of Hash(Symbol, String))
      input_tag(raw_options) do |str_result|
        str_result << "<input type=\"hidden\" id=\"#{HTML.escape(object_name.to_s)}_#{HTML.escape(method.to_s)}\" "
        str_result << "name=\"#{HTML.escape(object_name.to_s)}[#{HTML.escape(method.to_s)}]\" "
        str_result << "value=\"#{HTML.escape(value.to_s)}\""
      end
    end

    def submit_tag(value = "Save", raw_options = [] of Hash(Symbol, String))
      input_tag(raw_options) do |str_result|
        str_result << "<input name=\"commit\" type=\"submit\" value=\"#{HTML.escape(value)}\""
      end
    end

    def link_to(name, url, raw_options = [] of Hash(Symbol, String))
      surrounded_tag(:a, HTML.escape(name), raw_options) do |str_result|
        str_result << " href=\"#{url}\""
      end
    end

    def label_tag(name, value, raw_options = [] of Hash(Symbol, String))
      surrounded_tag(:label, HTML.escape(value), raw_options) do |str_result|
        str_result << " for=\"#{name}\""
      end
    end

    def check_box_tag(object_name, method, value = "1", checked = false, raw_options = [] of Hash(Symbol, String))
      input_tag(raw_options) do |str_result|
        str_result << "<input type=\"checkbox\" id=\"#{HTML.escape(object_name.to_s)}_#{HTML.escape(method.to_s)}\" "
        str_result << "name=\"#{HTML.escape(object_name.to_s)}[#{HTML.escape(method.to_s)}]\" "
        str_result << "value =\"#{value}\" "
        str_result << "checked =\"checked\"" if checked
      end
    end

    def radio_button_tag(object_name, method, value = "1", checked = false, raw_options = [] of Hash(Symbol, String))
      input_tag(raw_options) do |str_result|
        str_result << "<input type=\"radio\" id=\"#{HTML.escape(object_name.to_s)}_#{HTML.escape(method.to_s)}\" "
        str_result << "name=\"#{HTML.escape(object_name.to_s)}[#{HTML.escape(method.to_s)}]\" "
        str_result << "value =\"#{value}\" "
        str_result << "checked =\"checked\"" if checked
      end
    end

    def form_tag(url, method = "post", raw_options = [] of Hash(Symbol, String))
      options = options_transfomed(raw_options)
      str_result = StringIO.new
      str_result << "<form action=\"#{HTML.escape(url)}\" method=\"#{HTML.escape(method)}\""
      str_result << " #{options}" unless options.empty?
      str_result << ">"
      str_body_result = StringIO.new
      str_result << yield(str_body_result)
      str_result << "</form>"
      str_result.to_s
    end

    def select_tag(object_name, method, collection, raw_options = [] of Hash(Symbol, String))
      option_tags = extract_option_tags(collection)
      surrounded_tag(:select, option_tags, raw_options) do |str_result|
        str_result << " id=\"#{HTML.escape(object_name.to_s)}_#{HTML.escape(method.to_s)}\""
        str_result << " name=\"#{HTML.escape(object_name.to_s)}[#{HTML.escape(method.to_s)}]\" "
      end
    end

    def content_tag(tag, value, raw_options = [] of Hash(Symbol, String))
      surrounded_tag(tag, value, raw_options) {}
    end
  end
end
