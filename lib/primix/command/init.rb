require "xcodeproj"

module Primix
  class Command
    class Init < Command

      self.summary = ""
      self.description = <<-DESC
      DESC

      def initialize(argv)
        @mixfile_path = Pathname.pwd + 'Mixfile'
        super argv
      end

      def run
        UI.section "Initialing Primix project" do
          UI.section "Creating `Mixfile` for Primix" do
            FileUtils.touch(@mixfile_path)
            @mixfile_path.open('w') do |source|
              source.puts "primix_version '#{VERSION}'\n\n"
            end
          end
          UI.section "Creating `Mix` and `Postmix` folder for Primix" do
            FileUtils.mkdir_p(config.mix_folder)
            FileUtils.mkdir_p(config.postmix_folder)
          end
          UI.section "Adding `Mix` and `Postmix` folder into project" do
            integrate_to_project
          end
          UI.section "Adding default mix file " do

          end
        end
      end

      def integrate_to_project
        project = Xcodeproj::Project.open(config.xcodeproj_path)
        project.main_group.find_subpath("Mix", true)
        project.main_group.find_subpath("Postmix", true)
        project.save
      end

      def validate!
        raise Informative, 'Existing Mixfile in directory' unless config.mixfile_in_dir(Pathname.pwd).nil?
      end
    end
  end
end
