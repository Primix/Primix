module Primix
  class Command
    class Install < Command
      self.summary = "Integrate primix into project."
      self.description = ""

      def initialize(argv)
        super
      end

      def self.run(argv)

      end

      def integrate_to_project
        xcodeprojs = Dir.glob("#{config.installation_root}/*.xcodeproj")
        project = Xcodeproj::Project.open(xcodeprojs.first)
        target = project.targets.first

        project.save
      end
    end
  end
end
