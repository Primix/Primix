require "primix/version"
require 'primix/analyzer'

module Primix
  autoload :Analyzer, 'primix/analyzer'
end

analyzer = Primix::Analyzer.new(".")
analyzer.analyze!
