require_relative 'base'

module Primix
  class Analyzer
    module AST
      class LetDecl < Base
        attr_reader :modifiers
        attr_reader :identifier
        attr_reader :real_type

        def initialize(children)
          super(:LET_DECL)
          if children.first.type == :let
            key_type = children.last
            @identifier = key_type.identifier
            @real_type = key_type.real_type
            @modifiers = []
          else
            let_vecl = children.last
            @identifier = let_vecl.identifier
            @real_type = let_vecl.real_type
            @modifiers = let_vecl.modifiers + children.first
          end
        end
      end
    end
  end
end
