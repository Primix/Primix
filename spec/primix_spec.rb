require 'spec_helper'
require 'json'

describe Primix::Analyzer, "#analyze!" do

  it "runs" do
    analyzer = Primix::Analyzer.new(".")
    analyzer.analyze!
  end
end
