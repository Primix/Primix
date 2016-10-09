module Primix
  class Command
    class Install < Command
      require "primix/analyzer"
      self.summary = "Integrate primix into project."
      self.description = ""

      def initialize(argv)
        super
      end

      def run
        analyzer = analyzer_for_project_folder "."
        analyzer.analyze!
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
    end
  end
end
