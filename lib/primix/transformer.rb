module Primix
  class Transformer
    attr_reader :data
    attr_accessor :all_swift_strings

    def initialize(data)
      @data = data
    end

    SWIFT_STRING_REGEX = /("([^"\\]|\\.)*")/
    PLACEHOLDER_STRING = /primix_placeholder_string_index_\d+/

    def transform!
      @all_swift_strings = data.scan(SWIFT_STRING_REGEX).map(&:first)

      replace_strings_by_placeholder
      result = transform_value(data)
      result = fill_strings_back_into_data(result)
    end

    def replace_strings_by_placeholder
      0.tap do |count|
        while data.match SWIFT_STRING_REGEX
          data.sub! SWIFT_STRING_REGEX, "primix_placeholder_string_index_#{count}"
          count += 1
        end
      end
    end

    def fill_strings_back_into_data(data)
      if data.is_a? Array
        data.map do |element|
          fill_strings_back_into_data element
        end
      elsif data.is_a? Hash
        {}.tap do |result|
          data.each do |key, value|
            key = fill_strings_back_into_data(key)
            value = fill_strings_back_into_data(value)
            result[key] = value
          end
        end
      elsif data.is_a?(String) && data.match(PLACEHOLDER_STRING)
        eval @all_swift_strings.shift
      else
        data
      end
    end

    def transform_value(value)
      value.strip!
      if is_bool?(value)
        transform_bool_value(value)
      elsif is_number?(value)
        eval value
      elsif is_array?(value)
        split_element_by_comma(value.strip[1..-2]).map { |v| transform_value v }
      elsif is_hash?(value)
        split_element_by_comma(value.strip[1..-2]).reduce({}) do |memo, v|
          key, value = v.split(":")
          memo[transform_value(key)] = transform_value(value)
          memo
        end
      else
        value
      end
    end

    def transform_bool_value(value)
      if value == "true"
        true
      elsif value == "false"
        false
      else
        raise "Unknown bool value #{value}."
      end
    end

    def is_bool?(value)
      value == "true" || value == "false"
    end

    def is_number?(value)
      value.match(/^-?\d*(\.\d+)?$/)
    end

    def is_array?(value)
      !is_hash?(value) && value.start_with?("[")
    end

    def is_hash?(value)
      false unless value.start_with? "["
      value.split(",").first.include? ":"
    end

    def split_element_by_comma(value)
      # p value
      [].tap do |result|
        [0, ""].tap do |level, current|
          value.chars.each_with_index do |char, index|
            level += 1 if char == "["
            level -= 1 if char == "]"
            if char != "," || level >= 1 || char == "]"
              current << char
            else
              result << current
              current = ""
            end
            if index == value.chars.count - 1
              result << current
            end
            # p current, value
          end
        end
      end
    end
  end
end
