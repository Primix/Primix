require 'spec_helper'

describe Primix::Analyzer, "#analyze!" do
  analyzer = Primix::Analyzer.new(".")
  analyzer.analyze!
end
