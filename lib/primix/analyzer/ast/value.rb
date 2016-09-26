require_relative 'base'

module Primix
  class Analyzer
    module AST
      class Value < Base
        attr_reader :value

        def initialize(children)
          super(:VALUE)
          @value = children.first
        end
      end
    end
  end
end
