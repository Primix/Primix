module Primix
  class Command
    class Install < Command
      require "primix/analyzer"
      require "primix/processor"

      self.summary = "Regenerate postmix files in folder."
      self.description = <<-DESC
      Run all scripts which located in mix folder with a suffix mix and generate
      swift files or execute commands.
      DESC

      attr_reader :project_folder

      def initialize(argv)
        super argv
        @project_folder = config.installation_root
      end

      def run
        clear_postmix_group
        require_mix_files
        analyzing_annotations
      end

      def clear_postmix_group
        project = config.xcodeproj

        postmix_group = project.main_group.find_subpath("Postmix", true)
        postmix_group.clear
        postmix_group.set_source_tree('SOURCE_ROOT')

        project.save
      end

      def require_mix_files
        Dir["#{config.installation_root}/Mix/*.rb"].select { |f| f.match(/_mix.rb/) }.each {|file| require ("#{file}")  }
      end

      def analyzing_annotations
        analyzer_for_project_folder.analyze!.each do |file, meta|
          meta.annotations.each do |annotation|
            Hash[ derived_processors.collect { |v| [v.command, v] }].each do |command, processor|
              if annotation.match(command)
                content = processor.new(meta).run!

                directory = postmix_file_folder file
                unless File.directory?(directory)
                  FileUtils.mkdir_p(directory)
                end

                file_path = "#{directory}/#{meta.name}+#{command}.swift"
                File.write file_path, content

                add_group_to_project(directory, file_path)
              end
            end
          end
        end
      end

      def add_group_to_project(group, file)
        project = config.xcodeproj

        current_group = project.main_group.find_subpath("#{group}", true)
        current_group.set_source_tree('SOURCE_ROOT')
        file_ref = current_group.new_reference(file)

        target = project.targets.first
        target.source_build_phase.files_references.each do |f|
          target.source_build_phase.remove_file_reference(f) if f == file_ref
        end
        target.add_file_references([file_ref])

        project.save
      end

      def validate!
        raise Informative, 'No Mixfile in current directory' unless config.mixfile_in_dir(Pathname.pwd)
      end

      private

      def analyzer_for_project_folder
        Primix::Analyzer.new @project_folder
      end

      def derived_processors
        ObjectSpace.each_object(Class).with_object([]) { |k,a| a << k if k < Primix::Processor }
      end

      def postmix_file_folder(file)
        project_root = Pathname.new (project_folder)
        postmix_folder = Pathname.new "Postmix"
        relative_folder = Pathname.new(File.dirname(file)).relative_path_from project_root
        postmix_folder + relative_folder
      end
    end
  end
end
