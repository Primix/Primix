module Primix
  class Annotation
    attr_reader :meta
    attr_reader :params

    class << self
      attr_accessor :command
    end

    def initialize(meta, *params)
      @meta = meta
      @params = params
    end
  end
end
