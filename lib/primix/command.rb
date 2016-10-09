require 'colored'
require 'claide'

module Primix
  class Command < CLAide::Command
    require_relative 'command/install'

    self.abstract_command = true
    self.command = 'mix'
    self.version = VERSION
    self.description = "Primix, make Swift 'dynamic' again."

    def self.run(argv)
      super argv
    end

    def initialize(argv)
      super
    end
  end
end
