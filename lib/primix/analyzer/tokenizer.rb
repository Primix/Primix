module Primix
  module Analyzer
    class Tokenizer

      attr_reader :content

      attr_accessor :tokens

      def initialize(content)
        @content = content
        @tokens = []s
      end

      def tokenize!
        split_contents
        filter_tokens
        join_bracket
        compact_return_type_operator
      end

      def split_contents
        chars = @content.split ""
        current_token = ""

        chars.each_with_index do |char, index|
          case char
          when "(", ")", "{", "}", "[", "]", ":", "=", "\"", "-", ">", "." then
            tokens << current_token if current_token != ""
            tokens << char
            current_token = ""
          when " ", "\n", "\t" then
            tokens << current_token if current_token != ""
            current_token = ""
          else
            current_token << char
          end
        end
      end

      def remove_deeper_brace_level
        brace_level = 0
        tokens.select do |token|
          case token
          when "{" then brace_level += 1
          when "}" then brace_level -= 1
          end
          brace_level <= 1 && token != "}"
        end + ["}"]
      end

      def join_bracket
        bracket_level = 0
        brackets = []
        bracket_start_index = 0
        tokens.each_with_index do |token, index|
          case token
          when "[" then
            bracket_level += 1
            bracket_start_index = index if bracket_level <= 1
          when "]" then
            brackets << (bracket_start_index..index) if bracket_level <= 1
            bracket_level -= 1
          end
        end
        brackets.reverse.each do |bracket|
            tokens[bracket] = tokens[bracket].join
        end
      end

      def compact_return_type_operator
        tokens = tokens.each_with_index do |token, index|
          next_token = tokens[index + 1]
          case [token, next_token]
          when ["-", ">"] then
            tokens[index..index+1] = ["->", nil]
          end
        end.compact
      end
    end
  end
end
