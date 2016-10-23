require "primix/analyzer/ast/method_decl"
require "primix/analyzer/ast/constructor"

module Primix
  class Analyzer
    class AnalyzeResult
      class Method
        attr_accessor :name
        attr_accessor :kindname
        attr_accessor :param_labels
        attr_accessor :param_keys
        attr_accessor :param_types
        attr_accessor :default_values
        attr_accessor :return_type
        attr_accessor :modifiers

        def initialize(element = nil)
          return unless element
          if element.type == :METHOD
            @name = element.identifier.lexeme
            @modifiers = element.modifiers.map(&:lexeme)
            param_types = element.param_types
            @param_labels   = param_types.map(&:label).map(&:lexeme)
            @param_keys     = param_types.map(&:key_type).map(&:identifier).map(&:lexeme)
            @default_values = param_types.map(&:key_type).map(&:default_value).map { |e| if e == nil then nil else Transformer.transform!(e.lexeme) end }
            @param_types    = param_types.map(&:key_type).map(&:real_type).map(&:desc)
            @return_type    = element.return_type.desc
            @kindname = if is_class_method?
                          "function.class"
                        elsif is_static_method?
                          "function.static"
                        else
                          "function.instance"
                        end
          end
        end

        def is_instance_method?
          !is_class_method? && !is_static_method?
        end

        def is_class_method?
          @modifiers.include? "class"
        end

        def is_static_method?
          @modifiers.include? "static"
        end

        def selector
          result = ""
          result += name
          result += "(" + @param_labels.map do |label|
            "#{label}:"
          end.join("") + ")"
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

        def to_hash
          hash = {}
          hash[:kindname] = kindname
          hash[:name] = name
          hash[:substructure] = []
          @param_labels.each_with_index do |label, index|
            kindname = "var.parameter"
            default  = @default_values[index]
            typename = @param_types[index]
            name     = @param_keys[index]
            hash[:substructure] << { :kindname => kindname, :defaultvalue => default, :name => name, :typename => typename }
          end
          hash
        end

        def call(*params)
          pairs = [].tap do |key_value_pairs|
            param_labels.each_with_index do |label, index|
              key_value_pairs << "#{label}: #{params[index]}"
            end
          end

          "#{@name}(#{pairs.join(", ")})"
        end

        class << self
          def from_hash(hash)
            method = Method.new
            method.kindname = hash[:kindname]
            method.name = hash[:name]

            method.default_values = []
            method.param_keys = []
            method.param_types = []
            hash[:substructure].each do |attribute|
              attribute.default_values << attribute[:defaultvalue]
              attribute.param_keys     << attribute[:name]
              attribute.param_types    << attribute[:typename]
            end
            method
          end
        end
      end
    end
  end
end
