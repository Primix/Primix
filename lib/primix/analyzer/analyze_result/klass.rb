module Primix
  class Analyzer
    class AnalyzeResult
      class Klass
        attr_reader   :name
        attr_accessor :functions
        attr_accessor :attributes

        def initialize(name)
          @name       = name
          @functions  = []
          @attributes = []
        end

        def append_function(function)
          @functions << function
        end

        def append_attribute(attribute)
          @attributes << attribute
        end
      end
    end
  end
end
