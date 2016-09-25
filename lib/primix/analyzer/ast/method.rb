require_relative 'base'

module Primix
  class Analyzer
    module AST
      class Method < Base
        attr_reader :modifiers
        attr_reader :identifier
        attr_reader :param_types
        attr_reader :return_type

        def initialize(children)
          super(:METHOD)
          # :modifier, :METHOD
          if children.first.type == :modifier
            method = children.last
            @modifiers = [children.first] + method.modifiers
            @identifier = method.identifier
            @param_types = method.param_types
            @return_type = method.return_type
          elsif children[1].type == :reduce
            method = children.first
            @modifiers = method.modifiers
            @identifier = method.identifier
            @param_types = method.param_types
            @return_type = children.last
          elsif children.count == 4
            @modifiers = []
            @identifier = children[1]
            @param_types = []
            @return_type = "Void"
          elsif children[3].type == :KEY_TYPES
            @modifiers = []
            @identifier = children[1]
            @param_types = children[3].key_types
            @return_type = "Void"
          elsif children[3].type == :KEY_TYPE
            @modifiers = []
            @identifier = children[1]
            @param_types = [children[3]]
            @return_type = "Void"
          end
        end
      end
    end
  end
end
