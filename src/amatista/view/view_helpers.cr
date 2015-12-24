require "html"

module Amatista
  # Set of helpers for the tag views
  module ViewHelpers
    private def options_transfomed(options = [] of Hash(Symbol, String))
      options.map do |key, value|
        "#{key.to_s} = \"#{HTML.escape(value.to_s)}\""
      end.join(" ")
    end

    private def extract_option_tags(collection)
      collection.inject("") do |acc, item|
        acc +
        surrounded_tag(:option, item[1], [] of Hash(Symbol, String)) do |str_result|
          str_result << " value =\"#{item[0]}\""
        end
      end
    end

    private def input_tag(raw_options)
      options = options_transfomed(raw_options)
      str_result = MemoryIO.new
      yield(str_result)
      str_result << " #{options}" unless options.empty?
      str_result << " />"
      str_result.to_s
    end

    private def surrounded_tag(tag, value, raw_options)
      options = options_transfomed(raw_options)
      str_result = MemoryIO.new
      str_result << "<#{tag.to_s}"
      yield(str_result)
      str_result << " #{options}" unless options.empty?
      str_result << ">"
      str_result << value
      str_result << "</#{tag.to_s}>"
      str_result.to_s
    end

  end
end
