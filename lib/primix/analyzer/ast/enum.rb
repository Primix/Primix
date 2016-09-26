require_relative 'base'

module Primix
  class Analyzer
    module AST
      class Enum < Base
        attr_reader :modifiers
        attr_reader :identifier
        attr_reader :real_type
        def initialize(children)
          super(:ENUM)
          if children.first.type == :modifier
            enum = children.last
            @modifiers = enum.modifiers
            @identifier = enum.identifier
            @real_type = enum.real_type
          elsif children.last == :identifier
            @modifiers = []
            @identifier = children.last
          else
            key_type = children.last
            @modifiers = []
            @identifier = key_type.identifier
            @real_type = key_type.real_type
          end
        end
      end
    end
  end
end
