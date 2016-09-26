require_relative 'base'

module Primix
  class Analyzer
    module AST
      class OuterKeyType < Base
        attr_reader :label
        attr_reader :key_type
        def initialize(children)
          super(:OUTER_KEY_TYPE)
          if children.count == 1
            @label = ""
            @key_type = children.last
          else
            label = children.first
            @label = label
            @label = "" if label == "_"
            @key_type = children.last
          end
        end
      end

      class OuterKeyTypes < Base
        attr_reader :outer_key_types
        def initialize(children)
          super(:OUTER_KEY_TYPES)
          @outer_key_types = [children.first]
          @outer_key_types << children.last
          @outer_key_types.flatten!
        end
      end
    end
  end
end
