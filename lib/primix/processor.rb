module Primix
  class Processor
    attr_reader :meta
    attr_reader :params

    class << self
      attr_accessor :command
      attr_accessor :category
    end

    self.category = :generate

    def initialize(meta, *params)
      @meta = meta
      @params = params
    end
  end
end
