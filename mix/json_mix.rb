require "primix"

class Json < Primix::Processor
  self.command = "json"

  def run!
"""extension #{meta_info.name} {
    static func parse(json: Any) -> #{meta_info.name}? {
        guard let json = json as? [String: Any] else { return nil }
        guard #{json_extraction_lists.join(",\n\t\t")} else { return nil }
        return #{meta_info.name}(#{meta_info.attributes.map { |a| "#{a.name}: #{a.name}" }.join(", ") })
    }
}"""
  end

  private

  def json_extraction_lists
    meta_info.attributes.map do |attr|
      "let #{attr.name} = json[\"#{attr.name}\"] as? #{attr.typename}"
    end
  end
end
