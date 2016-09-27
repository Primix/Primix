require_relative 'base'

module Primix
  class Analyzer
    module AST
      class Constructor < Base
        attr_reader :param_types

        def initialize(children)
          super(:CONSTRUCTOR)
          if children.size == 3
            @param_types = []
          elsif children.size == 4
            if children[2].type == :OUTER_KEY_TYPE
              @param_types = [children[2]]
            else
              @param_types = children[2]
            end
          end
        end
      end
    end
  end
end
