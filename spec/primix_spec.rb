require 'spec_helper'
require 'json'
require_relative 'json'

describe Primix::Analyzer, "#analyze!" do
  analyzer = Primix::Analyzer.new(".")
  file_klass_hash = analyzer.analyze!
  # file_klass_hash.each do |key, value|
  #   file_klass_hash[key] = value.to_hash
  # end

  file_klass_hash.each do |_, klass|
    meta = klass
    puts Json.new(meta).generate!
  end
  # puts file_klass_hash
end
