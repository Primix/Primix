require "primix/version"

module Primix

  class PlainInformative < StandardError; end

  # Indicates an user error. This is defined in cocoapods-core.
  #
  class Informative < PlainInformative
    def message
      "[!] #{super}".red
    end
  end

  require "fileutils"
  require "pathname"

  require "primix/config"

  # Loaded immediately after dependencies to ensure proper override of their
  # UI methods.
  #
  require 'primix/user_interface'

  autoload :Analyzer,    'primix/analyzer'
  autoload :Command,     'primix/command'
  autoload :Processor,   'primix/processor'
  autoload :Transformer, 'primix/transformer'
end
