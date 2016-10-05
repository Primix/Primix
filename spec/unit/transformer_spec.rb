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

    it "transforms ordinary strings" do
      expect(transform_data("\"11\"")).to eq("11")
      expect(transform_data("\"draveness\"")).to eq("draveness")
    end

    it "transforms string with escaped character" do
      expect(transform_data("\"111\\\"\\\"111\"")).to eq("111\"\"111")
    end

    it "transforms integer array" do
      expect(transform_data("[1, 2, 3]")).to eq([1, 2, 3])
      expect(transform_data("[1]")).to eq([1])
    end

    it "transforms complicated array" do
      expect(transform_data("[true, \"string\", 3]")).to eq([true, "string", 3])
    end

    it "transforms nested array" do
      expect(transform_data("[1, 2, 3, [4, 5, 6]]")).to eq([1, 2, 3, [4, 5, 6]])
    end

    it "tramsforms ordinary dictionaries" do
      expect(transform_data("[1: 6]")).to eq({ 1 => 6 })
      expect(transform_data("[ \"key\": \"value\"]")).to eq({ "key" => "value" })
    end

    it "transforms complicated nested dictionaries" do
      expect(transform_data("[ \"key\": \"value\", 1: [1, 2, 3, \"haha\"]]")).to eq({ "key" => "value" , 1 => [1, 2, 3, "haha"]})
    end

    def transform_data(data)
      create_transformer(data).transform!
    end

    def create_transformer(data)
      Transformer.new(data)
    end
  end
end
