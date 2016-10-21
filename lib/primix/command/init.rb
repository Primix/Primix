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
          UI.section "Creating `mix` and `postmix` folder for Primix" do
            FileUtils.mkdir_p(config.mix_folder)
            FileUtils.mkdir_p(config.post_mix_folder)
          end
        end
      end

      def validate!
        raise Informative, 'Existing Mixfile in directory' unless config.mixfile_in_dir(Pathname.pwd).nil?
      end
    end
  end
end
