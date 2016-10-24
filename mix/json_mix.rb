require "primix"

class Json < Primix::Processor
  self.command = "json"

  def run!
"""extension #{meta.name} {
    static func parse(json: Any) -> #{meta.name}? {
        guard let json = json as? [String: Any] else { return nil }
        guard #{json_extraction_lists.join(",\n\t\t\t")} else { return nil }
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
      extract_from_json = extract_from_json(attr)
      if transformer
        transformer_from_type = transformer.param_types.first
        if transformer_from_type == "Any"
          "let #{attr.name} = #{extract_from_json}.flatMap(#{meta.name}.#{transformer.name})"
        else
          "let #{attr.name} = (#{extract_from_json} as? #{transformer_from_type}).flatMap(#{meta.name}.#{transformer.name})"
        end
      else
        "let #{attr.name} = #{extract_from_json} as? #{attr.typename}"
      end
    end
  end

  def extract_from_json(attr)
    json_key_path = json_property_hash[attr.name] || attr.name
    key_paths = json_key_path.split(".")
    result = "json"
    key_paths.each_with_index do |key_path, index|
      if index == key_paths.count - 1
        result += "[\"#{key_path}\"]"
      else
        result = "(#{result}[\"#{key_path}\"] as? [String: Any])?"
      end
    end
    result
  end

  def json_property_hash
    meta.attributes.detect { |a| a.name == "JSONKeyPathByPropertyKey" && a.is_static_attr? }.default_value
  end

  def key_paths
    meta.attributes.select { |attr| attr.is_instance_attr? }
  end
end
