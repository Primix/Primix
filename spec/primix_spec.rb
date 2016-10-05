require 'spec_helper'
require 'json'

describe Primix::Analyzer, "#analyze!" do
  analyzer = Primix::Analyzer.new(".")
  file_klass_hash = analyzer.analyze!
  file_klass_hash.each do |key, value|
    file_klass_hash[key] = value.to_hash
  end
  puts JSON.pretty_generate(file_klass_hash)
end
