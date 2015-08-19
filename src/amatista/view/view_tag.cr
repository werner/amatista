require "./view_helpers"

module Amatista
  module ViewTag
    include ViewHelpers
    
    def text_field(object_name, method, raw_options = [] of Hash(Symbol, String))
      options = options_transfomed(raw_options)
      str_result = StringIO.new
      str_result << "<input type=\"text\" id=\"#{object_name}_#{method}\" name=\"#{object_name}[#{method}]\""
      str_result << " #{options}" unless options.empty?
      str_result << " />"
      str_result.to_s
    end

    def form_tag(url, method = "post", raw_options = [] of Hash(Symbol, String))
      options = options_transfomed(raw_options)
      str_result = StringIO.new
      str_result << "<form action=\"#{url}\" method=\"#{method}\""
      str_result << " #{options}" unless options.empty?
      str_result << ">"
      str_body_result = StringIO.new
      str_result << yield(str_body_result)
      str_result << "</form>"
      str_result.to_s
    end

  end
end
