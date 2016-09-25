module Primix
  class Analyzer
    require "primix/analyzer/tokenizer"
    require "primix/analyzer/parser"

    attr_reader :project_folder

    def initialize(project_folder)
      @project_folder = project_folder
    end

    def analyze!
      Dir.glob("#{project_folder}/**/*.swift").select { |file|
        content = File.read file
        content.match(/\/\/@/)
        true
      }.each { |file|
        content = File.read file
        tokenizer = create_tokenizer content
        parser = Parser.new(tokenizer.tokenize!)
        parser.parse!
      }
    end

    def create_tokenizer(file)
      Tokenizer.new file
    end
  end
end
