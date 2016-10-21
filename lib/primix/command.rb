require 'colored'
require 'claide'

module Primix
  class Command < CLAide::Command
    require_relative 'command/init'
    require_relative 'command/install'

    include Config::Mixin

    self.abstract_command = true
    self.command = 'mix'
    self.version = VERSION
    self.description = "Primix, Make Swift 'dynamic' again."

    def self.run(argv)
      super argv
    end

    def initialize(argv)
      config.verbose = true
      super
    end
  end
end
