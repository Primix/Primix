require "primix"

class Json < Primix::Annotation
  self.command = "jsoncop"

  def generate!
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
      "let #{attr.name} = json[\"#{attr.name}\"] as? #{attr.typename}"
    end
  end
end



# extension <%= meta.name %> {
#     static func parse(json: Any) -> <%= meta.name %>? {
#         <% meta.attributes.map do |attr| %>
#           <%= "let #{attr.name} = json[\"#{attr.name}\"] as? #{attr.typename}" %>
#         <% end %>
#     }
# }
