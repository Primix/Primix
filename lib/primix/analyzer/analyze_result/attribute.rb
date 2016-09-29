module Primix
  class Analyzer
    class AnalyzeResult
      class Attribute
        attr_reader :name
        attr_reader :value

        def initialize(name, value)
          @name = name
          @value = value
        end
      end
    end
  end
end
