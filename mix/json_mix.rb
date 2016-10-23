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
      transformer = "#{attr.name}Transformer"
      if meta.respond_to_static_method? transformer
        "let #{attr.name} = json[\"#{attr.name}\"].flatMap(#{meta.name}.#{transformer})"
      else
        "let #{attr.name} = json[\"#{attr.name}\"] as? #{attr.typename}"
      end
    end
  end
end
