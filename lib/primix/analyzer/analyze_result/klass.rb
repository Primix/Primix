module Primix
  class Analyzer
    class AnalyzeResult
      class Klass
        attr_reader :name
        attr_accessor :methods
        attr_accessor :attributes

        def initialize(name)
          @name = name
          @methods = []
          @attributes = []
        end

        def append_method(method)
          @methods << method
        end

        def append_attribute(attribute)
          @attributes << attribute
        end

      end
    end
  end
end
