require_relative 'base'

module Primix
  class Analyzer
    module AST
      class KeyType < Base
        attr_reader :identifier
        attr_reader :real_type
        attr_reader :default_value
        def initialize(children)
          super(:KEY_TYPE)

          case children.map(&:type)
          when [:identifier, :colon, :TYPE] then
            @identifier = children.first
            @real_type  = children.last
            @default_value = nil
          when [:KEY_TYPE, :equal, :VALUE] then
            key_type = children.first
            @identifier = key_type.identifier
            @real_type = key_type.real_type
            @default_value = children.last
          end
        end
      end
    end
  end
end
