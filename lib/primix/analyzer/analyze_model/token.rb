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
        when "var" then :var
        when "let" then :let
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
        # when /\".*\"/ then :string_literal
        # when /^\d+$/ then :number_literal
        # when /^\d+\.\d+$/ then :float_literal
        # when /^(true|false)$/ then :bool_literal
        else :identifier
        end
      end
    end
  end
end
