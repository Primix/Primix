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

        FileUtils.mkdir_p "#{@project_folder}/postmix"

        Dir["#{@project_folder}/mix/*.rb"].select { |f| f.match(/_mix.rb/) }.each {|file| require ("#{Dir.pwd}/#{file}")  }

        command_processor_hash = Hash[ derived_processors.collect { |v| [v.command, v] }]
        file_meta_hash.each do |file, meta|
          meta.annotations.each do |annotation|
            command_processor_hash.each do |command, processor|
              if annotation.match(command)
                content = processor.new(meta).run!

                directory = File.dirname "#{@project_folder}/postmix/#{file}"
                unless File.directory?(directory)
                  FileUtils.mkdir_p(directory)
                end

                File.write "#{directory}/#{meta.name}+#{command}.swift", content
              end
            end
          end
        end

      end

      def integrate_to_project
        xcodeprojs = Dir.glob("#{config.installation_root}/*.xcodeproj")
        project = Xcodeproj::Project.open(xcodeprojs.first)
        # target = project.targets.first

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
