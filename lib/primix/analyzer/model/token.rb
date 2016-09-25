module Primix
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
      when "(" then :left_paranthesis
      when ")" then :right_paranthesis
      when "{" then :left_brace
      when "}" then :right_brace
      when "[" then :left_bracket
      when "]" then :right_bracket
      when ":" then :colon
      when "=" then :equal
      when "," then :comma
      when "?" then :question
      when "!" then :bang
      when "static", "class", "public", "private", "internal", "fileprivate", "open", "dynamic", "weak", "@objc" then :modifier
      else :token
      end
    end
  end
end
