require "primix/analyzer/ast/method"
require "primix/analyzer/ast/constructor"

module Primix
  class Analyzer
    class AnalyzeResult
      class Method
        attr_reader :name
        attr_reader :param_labels
        attr_reader :param_keys
        attr_reader :param_types
        attr_reader :default_values
        attr_reader :return_type
        attr_reader :modifiers

        def initialize(element)
          if element.type == :METHOD
            @name = element.identifier.lexeme
            @modifiers = element.modifiers
            param_types = element.param_types
            @param_labels   = param_types.map(&:label).map(&:lexeme)
            @param_keys     = param_types.map(&:key_type).map(&:identifier).map(&:lexeme)
            @default_values = param_types.map(&:key_type).map(&:default_value).map { |e| if e == nil then nil else e.lexeme end }
            @param_types    = param_types.map(&:key_type).map(&:real_type).map(&:desc)
            @return_type    = element.return_type.desc
          end
        end

        def is_class_method?
          @modifiers.include? "class"
        end

        def is_static_method?
          @modifiers.include? "static"
        end

        def signature
          result = ""
          if is_class_method?
            result += "class "
          elsif is_static_method?
            result += "static "
          end
          result += "func "
          result += name
          result += "(" + @param_labels.each_with_index.map do |label, index|
            default = @default_values[index]
            "#{label} #{@param_keys[index]}: #{@param_types[index]}" + if default then " = #{default}" else "" end
          end.join(", ") + ")" +  " -> " + @return_type
        end
      end
    end
  end
end
