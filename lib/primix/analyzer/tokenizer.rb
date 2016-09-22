module Primix
  module Analyzer
    class Tokenizer

      attr_reader :content

      def initialize(content)
        @content = content
      end

      def tokenize!
        filter_tokens(split_contents)
      end

      def split_contents
        chars = @content.split ""
        tokens = []
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
        tokens
      end

      def filter_tokens(tokens)
        brace_level = 0
        tokens.select do |token|
          case token
          when "{" then brace_level += 1
          when "}" then brace_level -= 1
          end
          brace_level <= 1 && token != "}"
        end + ["}"]
      end
    end
  end
end
