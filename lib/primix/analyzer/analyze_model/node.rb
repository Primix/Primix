module Primix
  class Analyzer
    class Node
      attr_reader :type
      attr_accessor :children

      def initialize(type, *children)
        @type = type
        @children = children
      end
    end
  end
end
