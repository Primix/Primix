require_relative 'base'

module Primix
  class Analyzer
    module AST
      class LetDecl < Base
        attr_reader :modifiers
        attr_reader :identifier
        attr_reader :real_type
        attr_reader :default_value

        def initialize(children)
          super(:LET_DECL)
          if children.first.type == :let
            key_type = children.last
            @identifier = key_type.identifier
            @real_type = key_type.real_type
            @default_value = key_type.default_value
            @modifiers = []
          else
            let_vecl = children.last
            @identifier = let_vecl.identifier
            @real_type = let_vecl.real_type
            @default_value = let_vecl.default_value
            @modifiers = let_vecl.modifiers << children.first
          end
        end
      end
    end
  end
end
