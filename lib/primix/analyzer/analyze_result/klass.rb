module Primix
  class Analyzer
    class AnalyzeResult
      class Klass
        attr_accessor :name
        attr_accessor :kindname
        attr_accessor :functions
        attr_accessor :attributes
        attr_accessor :annotations

        def initialize(name, kindname)
          @name        = name
          @kindname    = kindname
          @functions   = []
          @attributes  = []
          @annotations = []
        end

        class << self
          def from_hash(hash)
            klass = Klass.new(hash[:name], hash[:kindname])
            klass.annotations = hash[:annotations]
            klass.functions   = []
            klass.attributes  = []
            hash[:substructure].each do |substructure|
              case substructure[:kindname]
              when /^var/
                klass.attributes << Attribute.from_hash(substructure)
              when /^function/
                klass.functions << Method.from_hash(substructure)
              else
                raise "Unknown substructure kindname: #{substructure[:kindname]}"
              end
            end
            klass
          end
        end

        def append_function(function)
          @functions << function
        end

        def append_attribute(attribute)
          @attributes << attribute
        end

        def append_annotation(annotation)
          @annotations << annotation
        end

        def append_annotations(annotations)
          @annotations += annotations
        end

        def to_hash
          {}.tap do |hash|
            hash[:kindname] = kindname
            hash[:name] = name
            hash[:substructure] = []
            hash[:substructure] += attributes.map(&:to_hash)
            hash[:substructure] += functions.map(&:to_hash)
            hash[:annotations]  = annotations
          end
        end
      end
    end
  end
end
