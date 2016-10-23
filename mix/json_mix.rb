require "primix"

class Json < Primix::Processor
  self.command = "json"

  def run!
"""extension #{meta.name} {
    static func parse(json: Any) -> #{meta.name}? {
        guard let json = json as? [String: Any] else { return nil }
        guard #{json_extraction_lists.join(",\n\t\t")} else { return nil }
        return #{meta.name}(#{key_paths.map { |a| "#{a.name}: #{a.name}" }.join(", ") })
    }
}"""
  end

  private

  def json_extraction_lists
    key_paths.map do |attr|
      transformer = meta.functions.detect do |func|
        func.name == "#{attr.name}Transformer" && func.is_static_method?
      end
      json_key_path = json_property_hash[attr.name] || attr.name
      if transformer
        transformer_from_type = transformer.param_types.first
        if transformer_from_type == "Any"
          "let #{attr.name} = json[\"#{json_key_path}\"].flatMap(#{meta.name}.#{transformer.name})"
        else
          "let #{attr.name} = (json[\"#{json_key_path}\"] as? #{transformer_from_type}).flatMap(#{meta.name}.#{transformer.name})"
        end
      else
        "let #{attr.name} = json[\"#{json_key_path}\"] as? #{attr.typename}"
      end
    end
  end

  def json_property_hash
    meta.attributes.detect { |a| a.name == "JSONKeyPathByPropertyKey" && a.is_static_attr? }.default_value
  end

  def key_paths
    meta.attributes.select { |attr| attr.is_instance_attr? }
  end
end
