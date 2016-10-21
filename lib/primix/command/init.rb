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
        UI.section "Initiating Primix for current project" do
          FileUtils.touch(@mixfile_path)
          @mixfile_path.open('w') do |source|
            source.puts "primix_version '#{VERSION}'\n\n"
          end

          FileUtils.mkdir_p(config.mix_folder)
          FileUtils.mkdir_p(config.postmix_folder)
          integrate_to_project

          UI.section "Adding default annotation processors" do
            [:json].each do |processor|
              UI.message "-> ".green + "Using #{processor} processor"
              add_annotation_processor(processor)
            end
          end
        end
      end

      def integrate_to_project
        project = Xcodeproj::Project.open(config.xcodeproj_path)
        ["Mix", "Postmix"].each do |group_name|
          group = project.main_group.find_subpath(group_name, true)
          group.clear
          group.set_source_tree('SOURCE_ROOT')
        end
        project.save
      end

      def add_annotation_processor(annotation)
        # path in iOS project
        annotation_file_path = "#{config.mix_folder}/#{annotation}_mix.rb"
        # path which relative to init.rb file
        origianl_path = Pathname.new(__FILE__) + Pathname.new("../../../../mix/#{annotation}_mix.rb")
        content = File.read origianl_path
        File.write annotation_file_path, content

        project = Xcodeproj::Project.open(config.xcodeproj_path)
        mix_group = project.main_group.find_subpath("Mix", true)
        mix_group.new_reference(annotation_file_path)
        project.save
      end

      # def validate!
      #   raise Informative, 'Existing Mixfile in directory' unless config.mixfile_in_dir(Pathname.pwd).nil?
      # end
    end
  end
end
