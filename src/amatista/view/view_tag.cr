require "./view_helpers"

module Amatista
  module ViewTag
    include ViewHelpers
    
    def text_field(object_name, method, raw_options = [] of Hash(Symbol, String))
      options = options_transfomed(raw_options)
      str_result = StringIO.new
      str_result << "<input type=\"text\" id=\"#{HTML.escape(object_name.to_s)}_#{HTML.escape(method.to_s)}\" "
      str_result << "name=\"#{HTML.escape(object_name.to_s)}[#{HTML.escape(method.to_s)}]\""
      str_result << " #{options}" unless options.empty?
      str_result << " />"
      str_result.to_s
    end

    def hidden_tag(object_name, method, value, raw_options = [] of Hash(Symbol, String))
      options = options_transfomed(raw_options)
      str_result = StringIO.new
      str_result << "<input type=\"hidden\" id=\"#{HTML.escape(object_name.to_s)}_#{HTML.escape(method.to_s)}\" "
      str_result << "name=\"#{HTML.escape(object_name.to_s)}[#{HTML.escape(method.to_s)}]\" "
      str_result << "value=\"#{HTML.escape(value.to_s)}\""
      str_result << " #{options}" unless options.empty?
      str_result << " />"
      str_result.to_s
    end

    def submit_tag(value = "Save", raw_options = [] of Hash(Symbol, String))
      options = options_transfomed(raw_options)
      str_result = StringIO.new
      str_result << "<input name=\"commit\" type=\"submit\" value=\"#{HTML.escape(value)}\""
      str_result << " #{options}" unless options.empty?
      str_result << " />"
      str_result.to_s
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

    def content_tag(tag, value, raw_options = [] of Hash(Symbol, String))
      options = options_transfomed(raw_options)
      str_result = StringIO.new
      str_result << "<#{tag.to_s}"
      str_result << " #{options}" unless options.empty?
      str_result << ">"
      str_result << value
      str_result << "</#{tag.to_s}>"
      str_result.to_s
    end

  end
end
