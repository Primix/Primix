module Primix
  class Analyzer
    class Tokenizer
      require_relative 'analyze_model/token'

      attr_reader :content
      attr_accessor :tokens
      attr_accessor :index

      def initialize(content)
        @content = content
        @tokens = []
        @index = 0
      end

      def tokenize!
        split_contents
        remove_deeper_brace_level
        compact_return_type_operator

        tokens.map! do |token|
          Token.new token
        end
      end

      def split_contents
        current_token = ""
        in_string = false

        while next_char != nil
          char = next_char
          case char
          when "\"" || in_string then
            current_token << char
            if is_literal_quote = char == "\"" && previous_char != "\\"
              in_string = !in_string
              if in_string == false
                @tokens << current_token
                current_token = ""
              end
            end
          when "(", ")", "{", "}", "[", "]", ":", "=", "-", ">", ".", " ", "\n", "\t" then
            if in_string
              current_token << char
            else
              if current_token != ""
                @tokens << current_token if current_token != ""
                current_token = ""
              end
              @tokens << char unless [" ", "\n", "\t"].include? char
            end
          else
            current_token << char
          end
          @index += 1
        end

      end

      def remove_deeper_brace_level
        0.tap do |level|
          @tokens = tokens.select do |token|
            case token
            when "{" then level += 1
            when "}" then level -= 1
            end
            level <= 1 && token != "}"
          end + ["}"]
        end
      end

      def compact_return_type_operator
        tokens.enum_for(:each_with_index).reverse_each do |token, index|
          previous_token = tokens[index - 1]
          case [previous_token, token]
          when ["-", ">"] then
            tokens[index-1..index] = "->"
          end
        end
      end

      def all_chars
        content.chars
      end

      def previous_char
        all_chars[index-1]
      end

      def next_char
        all_chars[index]
      end
    end
  end
end
