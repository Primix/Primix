module Primix
  class Analyzer
    class Tokenizer
      require 'primix/helper'
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
        remove_unresolving_statement
        remove_modifiers
        compact_return_type_operator
        compact_array_and_hash_value
        @tokens
      end

      def split_contents
        current_token = ""
        in_string = false

        while next_char != nil
          char = next_char
          case char
          when "\"" || in_string then
            current_token << char
            if char == "\"" && previous_char != "\\"
              in_string = !in_string
              if in_string == false
                @tokens << current_token
                current_token = ""
              end
            end
          when "(", ")", "{", "}", "[", "]", ":", "=", "-", ">", " ", ",", "\n", "\t" then
            if in_string
              current_token << char
            else
              if current_token != ""
                @tokens << current_token if current_token != ""
                current_token = ""
              end
              @tokens << char unless [" ", "\t"].include? char
            end
          else
            current_token << char
          end
          @index += 1
        end
      end

      def remove_modifiers
        @tokens.select! do |token|
          !(["lazy", "public", "private", "internal", "fileprivate",
             "open", "dynamic", "weak", "@objc", "@discardableResult",
             "required", "final", "convenience"].include? token)
        end
      end

      def remove_unresolving_statement
        @tokens = tokens
          .remove_newlines_in_brace
          .compact_with_element("\n")
          .reduce([[]]) { |memo, obj| if obj == "\n" then memo << [] else memo.last << obj end; memo }
          .select { |stmt| [["{"], ["}"]].any?(&stmt.method(:==)) || %w[let var func init struct class].any?(&stmt.method(:include?)) }
          .flatten
          .reject { |element| element == "\n" }
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

      def compact_array_and_hash_value
        [0, 0].tap do |level, bracket_end_index|
          tokens.enum_for(:each_with_index).reverse_each do |token, index|
            case token
            when "]" then
              level += 1
              bracket_end_index = index if level <= 1
            when "[" then
              if level <= 1 && tokens[index-1] == "="
                range = index..bracket_end_index
                tokens[range] = tokens[range].join
              end
              level -= 1
            end
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
