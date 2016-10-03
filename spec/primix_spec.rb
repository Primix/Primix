require 'spec_helper'

describe Primix::Analyzer, "#analyze!" do
  analyzer = Primix::Analyzer.new(".")
  p analyzer.analyze!.first.attributes.first.to_hash
end
