module Primix
  module Analyzer
    class Token
      attr_reader :lexeme
      attr_reader :token_type

      def initialize(lexeme)
        @lexeme = lexeme
      end

      def token_type
        case lexeme
        when "struct" then :struct
        when "let", "var" then :var
        when "func" then :func
        when "enum" then :enum
        when "->" then :reduce
        when "(" then :left_paranthesis
        when ")" then :right_paranthesis
        when "{" then :left_brace
        when "}" then :right_brace
        when ":" then :colon
        when "=" then :equal
        when "," then :comma
        when "static", "class", "public", "private", "internal", "fileprivate", "open", "dynamic", "weak", "@objc" then :modifiers
        else :token
        end
      end
    end
  end
end
