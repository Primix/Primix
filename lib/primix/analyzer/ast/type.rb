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

        def desc
          "#{identifier.lexeme}"
        end
      end

      class OptionalType < Base
        attr_reader :identifier

        def initialize(children)
          super(:TYPE)
          @identifier = children.first
        end

        def desc
          "#{identifier.desc}?"
        end
      end

      class NonNilOptionalType < Base
        attr_reader :identifier

        def initialize(children)
          super(:TYPE)
          @identifier = children.first
        end

        def desc
          "#{identifier.desc}!"
        end
      end

      class WrappedType < Base
        attr_reader :identifier

        def initialize(children)
          super(:TYPE)
          @identifier = children[1]
        end

        def desc
          "(#{identifier.desc})"
        end
      end

      class ArrayType < Base
        attr_reader :element_type

        def initialize(children)
          super(:TYPE)
          @element_type = children[1]
        end

        def desc
          "[#{element_type.desc}]"
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

        def desc
          "[#{key_type.desc}: #{value_type.desc}]"
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

        def desc
          "#{param_type.desc} -> #{return_type.desc}"
        end
      end
    end
  end
end
