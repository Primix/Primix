require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative 'lib/primix/version'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :rspec => :spec

task :install => [:build, :install, :clean]

task :release => [:build, :push, :clean]

task :push do
  system %(gem push #{build_product_file})
end

task :build do
  system %(gem build primix.gemspec)
end

task :install do
  system %(gem install #{build_product_file})
end

task :clean do
  system %(rm *.gem)
end

def build_product_file
  "primix-#{Primix::VERSION}.gem"
end
