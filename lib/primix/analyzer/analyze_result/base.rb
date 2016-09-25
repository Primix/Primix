module Primix
  class AnalyzeResult
    class Base
      attr_reader :type

      def initialize(type)
        @type = type
      end
    end
  end
end
