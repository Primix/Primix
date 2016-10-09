require 'spec_helper'
require 'json'

describe Primix::Analyzer, "#analyze!" do

  it "runs" do
    analyzer = Primix::Analyzer.new(".")
    file_klass_hash = analyzer.analyze!

    file_klass_hash.each do |_, klass|
      meta = klass
      # puts Json.new(meta).generate!
    end
    # puts file_klass_hash
  end
end
