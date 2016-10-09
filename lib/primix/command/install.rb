module Primix
  class Command
    class Install < Command
      require "primix/analyzer"
      require "primix/processor"

      self.summary = "Integrate primix into project."
      self.description = ""

      attr_reader :project_folder

      def initialize(argv)
        super argv
        @project_folder = argv.arguments[0] || "."
      end

      def run
        analyzer = analyzer_for_project_folder @project_folder
        file_meta_hash = analyzer.analyze!

        Dir["mix/*.rb"].select { |f| f.match(/_mix.rb/) }.each {|file| require ("#{Dir.pwd}/#{file}")  }

        command_processor_hash = derived_processors.map do |processor|
          { processor.command => processor }
        end
        p command_processor_hash
        file_meta_hash.each do |file, meta|

        end

      end

      def integrate_to_project
        xcodeprojs = Dir.glob("#{config.installation_root}/*.xcodeproj")
        project = Xcodeproj::Project.open(xcodeprojs.first)
        # target = project.targets.first

        project.save
      end

      private

      def analyzer_for_project_folder(project_folder)
        Primix::Analyzer.new project_folder
      end

      def derived_processors
        ObjectSpace.each_object(Class).with_object([]) { |k,a| a << k if k < Primix::Processor }
      end

    end
  end
end
