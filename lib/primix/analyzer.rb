module Primix
  class Analyzer
    require "primix/analyzer/tokenizer"
    require "primix/analyzer/parser"

    attr_reader :project_folder

    def initialize(project_folder)
      @project_folder = project_folder
    end

    def analyze!
      {}.tap do |file_klass_hash|
        files_contain_annotation.map { |file|
          annotation_content_hash = extract_content file
          annotation_content_hash.each do |annotations, content|
            tokenizer = create_tokenizer content
            parser = Parser.new(tokenizer.tokenize!)
            klass = parser.parse!
            klass.append_annotations(annotations)
            file_klass_hash[file] = klass
          end
        }
      end
    end

    def files_contain_annotation
      Dir.glob("#{project_folder}/**/*.swift").select { |file|
        content = File.read file
        content.match(/\/\/@/)
      }
    end

    def extract_content(file)
      file_content = File.read file
      file_content = file_content.gsub(/\/\*.*\*\//m, "").gsub(/\/\/(?!@).*/, "")

      annotation_content_hash = {}
      level = 0

      [[], []].tap do |annotations, content|
        file_content.split("\n").each do |line|
          if annotations.count != 0
            if line.match(/\/\/@/)
              annotations << line[2..-1]
            else
              content << line
              purify_line = line.gsub(/".*"/, "")
              level += purify_line.scan("{").count
              level -= purify_line.scan("}").count
              if level == 0
                annotation_content_hash[annotations] = content.join("\n")
                content = []
                annotations = []
              end
            end
          elsif line.match(/\/\/@/)
            annotations << line[2..-1]
          end
        end
      end
      annotation_content_hash
    end

    def create_tokenizer(file)
      Tokenizer.new file
    end
  end
end
