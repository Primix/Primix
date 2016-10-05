require File.expand_path('../../spec_helper', __FILE__)

module Primix
  describe Transformer do
    it "transforms bool" do
      expect(transform_data("true")).to eq(true)
      expect(transform_data("false")).to eq(false)
    end

    it "transforms integer with positive value" do
      expect(transform_data("11")).to eq(11)
    end

    it "transforms float with positive value" do
      expect(transform_data("1.1")).to eq(1.1)
    end

    it "transforms float with negative value" do
      expect(transform_data("-1.1")).to eq(-1.1)
    end

    it "transforms common string" do
      expect(transform_data("\"11\"")).to eq("11")
      expect(transform_data("\"draveness\"")).to eq("draveness")
    end

    it "transforms string with escaped character" do
      expect(transform_data("\"111\"\"111\"")).to eq("111\"\"111")
    end

    it "transforms array" do

    end

    it "tramsforms dictionary" do

    end

    def transform_data(data)
      create_transformer(data).transform!
    end

    def create_transformer(data)
      Transformer.new(data)
    end
  end
end
