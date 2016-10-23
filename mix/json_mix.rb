require "primix"

class Json < Primix::Processor
  self.command = "json"

  def run!
"""extension #{meta.name} {
    static func parse(json: Any) -> #{meta.name}? {
        guard let json = json as? [String: Any] else { return nil }
        guard #{json_extraction_lists.join(",\n\t\t")} else { return nil }
        return #{meta.name}(#{meta.attributes.map { |a| "#{a.name}: #{a.name}" }.join(", ") })
    }
}"""
  end

  private

  def json_extraction_lists
    meta.attributes.map do |attr|
      transformer = meta.functions.detect do |func|
        func.name == "#{attr.name}Transformer" && func.is_static_method?
      end
      if transformer
        transformer_from_type = transformer.param_types.first
        if transformer_from_type == "Any"
          "let #{attr.name} = json[\"#{attr.name}\"].flatMap(#{meta.name}.#{transformer.name})"
        else
          "let #{attr.name} = (json[\"#{attr.name}\"] as? #{transformer_from_type}).flatMap(#{meta.name}.#{transformer.name})"
        end
      else
        "let #{attr.name} = json[\"#{attr.name}\"] as? #{attr.typename}"
      end
    end
  end
end
