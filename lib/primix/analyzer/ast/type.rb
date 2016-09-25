require_relative 'base'
require 'colored'

module Primix
  class Analyzer
    module AST
      class Type < Base
        attr_reader :identifier

        def initialize(children)
          super(:TYPE)
          @identifier = children.first
        end

        def description
          "#{self.class} #{identifier}"
        end
      end

      class OptionalType < Base
        attr_reader :identifier

        def initialize(children)
          super(:TYPE)
          @identifier = children.first
        end

        def description
          "#{self.class} #{identifier}"
        end
      end

      class NonNilOptionalType < Base
        attr_reader :identifier

        def initialize(children)
          super(:TYPE)
          @identifier = children.first
        end

        def description
          "#{self.class} #{identifier}"
        end
      end

      class WrappedType < Base
        attr_reader :identifier

        def initialize(children)
          super(:TYPE)
          @identifier = children[1]
        end

        def description
          "#{self.class} #{identifier}"
        end
      end

      class ArrayType < Base
        attr_reader :element_type

        def initialize(children)
          super(:TYPE)
          @element_type = children[1]
        end

        def description
          "#{self.class} #{element_type}"
        end
      end

      class HashType < Base
        attr_reader :key_type
        attr_reader :value_type

        def initialize(children)
          super(:TYPE)
          @key_type   = children[1]
          @value_type = children[3]
        end

        def description
          "#{self.class} #{key_type}: #{value_type}"
        end
      end

      class FunctionType < Base
        attr_reader :param_type
        attr_reader :return_type

        def initialize(children)
          super(:TYPE)
          @param_type  = children[0]
          @return_type = children[2]
        end

        def description
          "#{self.class} #{param_type} -> #{return_type}"
        end
      end
    end
  end
end
