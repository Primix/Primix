module Primix
  class Analyzer
    class AnalyzeResult
      class Attribute
        attr_accessor :name
        attr_accessor :kindname
        attr_accessor :typename
        attr_accessor :value
        attr_accessor :default_value
        attr_accessor :modifiers

        def initialize(element = nil)
          return unless element
          @name     = element.identifier.lexeme
          @typename = element.real_type.desc
          @modifiers = element.modifiers.map(&:lexeme)
          @kindname = if is_class_attr?
                        "var.class"
                      elsif is_static_attr?
                        "var.static"
                      else
                        "var.instance"
                      end
          if element.default_value
            @default_value = Transformer.transform!(element.default_value.value.lexeme)
          end
        end

        def is_instance_attr?
          !is_class_attr? && !is_static_attr?
        end

        def is_class_attr?
          @modifiers.include? "class"
        end

        def is_static_attr?
          @modifiers.include? "static"
        end

        def to_hash
          hash = {}
          hash[:kindname] = kindname
          hash[:name] = name
          hash[:typename] = typename
          hash[:defaultvalue] = default_value
          hash
        end

        class << self
          def from_hash(hash)
            attribute = Attribute.new
            attribute.kindname = hash[:kindname]
            attribute.typename = hash[:typename]
            attribute.name = hash[:name]
            attribute.default_value = hash[:defaultvalue]
            attribute
          end
        end
      end
    end
  end
end
