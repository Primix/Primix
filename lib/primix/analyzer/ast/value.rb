require_relative 'base'

module Primix
  class Analyzer
    module AST
      class Value < Base
        attr_reader :value

        def initialize(children)
          super(:KEY_TYPES)
          @key_types = [children.first]
          @key_types << children.last
          @key_types.flatten!
        end
      end
    end
  end
end
