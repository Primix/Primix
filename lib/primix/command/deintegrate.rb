require "xcodeproj"

module Primix
  class Command
    class Deintegrate < Command

      self.summary = "Deintegrate primix from current project."
      self.description = <<-DESC
      DESC

      def initialize(argv)
        super argv
        @project = config.xcodeproj
      end

      def run
        postmix_group = @project.main_group.find_subpath("Postmix", true)
        postmix_group.clear
        postmix_group.remove_from_project

        mix_group = @project.main_group.find_subpath("Mix", true)
        mix_group.clear
        mix_group.remove_from_project

        FileUtils.rm(Pathname.pwd + 'Mixfile', :force => true)

        FileUtils.rm_rf(config.mix_folder)
        FileUtils.rm_rf(config.postmix_folder)

        @project.save
      end
    end
  end
end
