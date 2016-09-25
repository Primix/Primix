module Primix
  class Analyzer
    class Token
      attr_reader :lexeme
      attr_reader :type

      def initialize(lexeme)
        @lexeme = lexeme
      end

      def type
        case lexeme
        when "struct" then :struct
        when "let", "var" then :var
        when "func" then :func
        when "enum" then :enum
        when "->" then :reduce
        when "(" then :l_paren
        when ")" then :r_paren
        when "{" then :l_brace
        when "}" then :r_brace
        when "[" then :l_square
        when "]" then :r_square
        when ":" then :colon
        when "=" then :equal
        when "," then :comma
        when "?" then :question
        when "!" then :bang
        when "static", "class", "public", "private", "internal", "fileprivate", "open", "dynamic", "weak", "@objc" then :modifier
        else :identifier
        end
      end
    end
  end
end
