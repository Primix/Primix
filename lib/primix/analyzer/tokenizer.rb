module Primix
  class Analyzer
    class Tokenizer
      require 'primix/analyzer/analyze_model/token'

      attr_reader :content

      attr_accessor :tokens

      def initialize(content)
        @content = content
        @tokens = []
      end

      def tokenize!
        split_contents
        remove_deeper_brace_level
        join_bracket
        compact_return_type_operator

        tokens.map! do |token|
          Token.new token
        end
      end

      def split_contents
        current_token = ""

        @content.split("").each_with_index do |char, index|
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

      def join_bracket
        # [0, 0].tap do |level, bracket_end_index|
        #   tokens.enum_for(:each_with_index).reverse_each do |token, index|
        #     case token
        #     when "]" then
        #       level += 1
        #       bracket_end_index = index if level <= 1
        #     when "[" then
        #       if level <= 1
        #         range = index..bracket_end_index
        #         tokens[range] = tokens[range].join
        #       end
        #       level -= 1
        #     end
        #   end
        # end
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
    end
  end
end
