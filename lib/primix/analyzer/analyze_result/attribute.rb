module Primix
  class Analyzer
    class AnalyzeResult
      class Attribute
        attr_reader :name
        attr_reader :typename
        attr_reader :value
        attr_reader :default_value
        attr_reader :modifiers

        def initialize(element)
          @name     = element.identifier.lexeme
          @typename = element.real_type.identifier.lexeme
          @modifiers = element.modifiers.map(&:lexeme)
          if element.default_value
            @default_value = element.default_value.value.lexeme
          end
        end

        def is_class_method?
          @modifiers.include? "class"
        end

        def is_static_method?
          @modifiers.include? "static"
        end

        def kindname
          if is_class_method?
            "var.class"
          elsif is_static_method?
            "var.static"
          else
            "var.instance"
          end
        end

        def to_hash
          hash = {}
          hash[:kindname] = kindname
          hash[:name] = name
          hash[:typename] = typename
          hash[:defaultvalue] = default_value
          hash
        end
      end
    end
  end
end
