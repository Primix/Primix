module Primix
  class Processor
    attr_reader :meta_info
    attr_reader :params

    class << self
      attr_accessor :command
      attr_accessor :category
    end

    self.category = :generate

    def initialize(meta_info, *params)
      @meta_info = meta_info
      @params    = params
    end
  end
end
