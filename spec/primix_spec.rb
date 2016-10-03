require 'spec_helper'
require 'json'

describe Primix::Analyzer, "#analyze!" do
  analyzer = Primix::Analyzer.new(".")
  json = analyzer.analyze!.map(&:to_hash)
  puts JSON.pretty_generate(json)
end
