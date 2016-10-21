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
        analyzer = analyzer_for_project_folder @project_folder
        file_meta_hash = analyzer.analyze!

        Dir["#{@project_folder}/mix/*.rb"].select { |f| f.match(/_mix.rb/) }.each {|file| require ("#{file}")  }

        command_processor_hash = Hash[ derived_processors.collect { |v| [v.command, v] }]
        file_meta_hash.each do |file, meta|
          meta.annotations.each do |annotation|
            command_processor_hash.each do |command, processor|
              if annotation.match(command)
                content = processor.new(meta).run!

                project_root = Pathname.new config.installation_root
                post_mix_folder = Pathname.new "postmix"
                relative_folder = Pathname.new(File.dirname(file)).relative_path_from project_root
                directory = post_mix_folder + relative_folder

                unless File.directory?(directory)
                  FileUtils.mkdir_p(directory)
                end

                File.write "#{directory}/#{meta.name}+#{command}.swift", content

                add_group_to_project(directory, "#{directory}/#{meta.name}+#{command}.swift")
              end
            end
          end
        end

      end

      def add_group_to_project(group, file)
        project = Xcodeproj::Project.open(config.xcodeproj_path)

        current_group = project.main_group.find_subpath("#{group}", true)
        current_group.set_source_tree('SOURCE_ROOT')
        file_ref = current_group.new_reference(file)

        target = project.targets.first
        target.add_file_references([file_ref])

        project.save
      end

      def validate!
        raise Informative, 'No Mixfile in current directory' unless config.mixfile_in_dir(Pathname.pwd)
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
