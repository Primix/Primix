require_relative 'base'

module Primix
  class Analyzer
    module AST
      class KeyType < Base
        attr_reader :identifier
        attr_reader :real_type
        def initialize(children)
          super(:KEY_TYPE)
          @identifier = children.first
          @real_type  = children.last
        end
      end
    end
  end
end
