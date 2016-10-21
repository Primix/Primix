require 'active_support/multibyte/unicode'

module Primix
  # Stores the global configuration of Primix.
  #
  class Config

    DEFAULTS = {
      :verbose             => true,
      :silent              => false,
      :skip_build          => false,
    }

    public

    attr_accessor :skip_build
    alias_method :skip_build?, :skip_build


    #-------------------------------------------------------------------------#

    # @!group UI

    # @return [Bool] Whether Primix should provide detailed output about the
    #         performed actions.
    #
    attr_accessor :verbose
    alias_method :verbose?, :verbose

    public

    #-------------------------------------------------------------------------#

    # @!group Initialization

    def verbose
      @verbose && !silent
    end

    public

    #-------------------------------------------------------------------------#

    # @!group Paths

    # @return [Pathname] the root of the Primix installation where the
    #         meta folder is located.
    #
    def installation_root
      current_dir = ActiveSupport::Multibyte::Unicode.normalize(Dir.pwd)
      current_path = Pathname.new(current_dir)
      unless @installation_root
        until current_path.root?
          if mixfile_in_dir(current_path)
            @installation_root = current_path
            break
          else
            current_path = current_path.parent
          end
        end
        @installation_root ||= Pathname.pwd
      end
      @installation_root
    end

    attr_writer :installation_root
    alias_method :project_root, :installation_root

    # Returns whether or not mixfile is in current project.
    #
    # @return [Bool]
    #
    def mixfile_exist?
      Pathname.new(mixfile_path).exist?
    end

    # Returns the path of the mixfile.
    #
    # @return [Pathname]
    # @return [Nil]
    #
    def mixfile_path
      @mixfile_in_dir ||= installation_root + 'mixfile'
    end

    def mix_folder
      installation_root + "mix"
    end

    def post_mix_folder
      installation_root + "postmix"
    end

    # Returns the path of the mixfile in the given dir if any exists.
    #
    # @param  [Pathname] dir
    #         The directory where to look for the meta.
    #
    # @return [Pathname] The path of the mixfile.
    # @return [Nil] If not meta was found in the given dir
    #
    def mixfile_in_dir(dir)
      candidate = dir + 'mixfile'
      if candidate.exist?
        return candidate
      end
      nil
    end

    def mixfile
      @mixfile ||= mixfile.from_file(mixfile_path) if mixfile_path
    end

    public

    #-------------------------------------------------------------------------#

    # @!group Singleton

    # @return [Config] the current config instance creating one if needed.
    #
    def self.instance
      @instance ||= new
    end

    # Sets the current config instance. If set to nil the config will be
    # recreated when needed.
    #
    # @param  [Config, Nil] the instance.
    #
    # @return [void]
    #
    class << self
      attr_writer :instance
    end

    # Provides support for accessing the configuration instance in other
    # scopes.
    #
    module Mixin
      def config
        Config.instance
      end
    end
  end
end
