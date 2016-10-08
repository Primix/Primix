require "primix"

class Json < Primix::Annotation
  # self.command = "jsoncop"

  def generate!
"""extension #{meta.name} {
    static func parse(json: Any) -> #{meta.name}? {
        guard let json = json as? [String: Any] else { return nil }
        guard let #{json_extraction_lists.join(",\n\t\t\t")} else { return nil }
        return #{meta.name}()
    }
}
"""
  end

  private

  def json_extraction_lists
    meta.attributes.map do |attr|
      "#{attr.name} = json[\"#{attr.name}\"] as? #{attr.typename}"
    end
  end
end
