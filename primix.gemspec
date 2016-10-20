# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'primix/version'

Gem::Specification.new do |spec|
  spec.name          = "primix"
  spec.version       = Primix::VERSION
  spec.authors       = ["Draveness"]
  spec.email         = ["stark.draven@gmail.com"]

  spec.summary       = %q{ Write a short summary, because Rubygems requires one.}
  spec.description   = %q{ Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/primix/primix"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"] + %w{ README.md LICENSE bin/mx }

  spec.executables = %w{ mx }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'colored',       '~> 1.2'
  spec.add_runtime_dependency 'claide',         '>= 1.0.0', '< 2.0'
  spec.add_runtime_dependency 'xcodeproj',      '~> 1.2'
  spec.add_runtime_dependency 'activesupport',  '>= 4.2.6', '< 5.0'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
