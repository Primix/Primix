module Primix
  class Analyzer
    module AST
      class Base
        attr_reader :type

        def initialize(type)
          @type = type
        end
      end
    end
  end
end
