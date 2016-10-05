require_relative 'base'

module Primix
  class Analyzer
    module AST
      class VarDecl < Base
        attr_reader :modifiers
        attr_reader :identifier
        attr_reader :real_type
        attr_reader :default_value

        def initialize(children)
          super(:VAR_DECL)
          if children.first.type == :var
            key_type = children.last
            @identifier = key_type.identifier
            @real_type = key_type.real_type
            @default_value = key_type.default_value
            @modifiers = []
          else
            var_decl = children.last
            @identifier = var_decl.identifier
            @real_type = var_decl.real_type
            @default_value = var_decl.default_value
            @modifiers = var_decl.modifiers << children.first
          end
        end
      end
    end
  end
end
