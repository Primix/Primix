module Primix
  class Analyzer
    class AnalyzeResult
      class Klass
        attr_reader   :name
        attr_reader   :kindname
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
