module Primix
  class Annotation
    attr_reader :meta
    attr_reader :params

    def initialize(meta, *params)
      @meta = meta
      @params = params
    end
  end
end
