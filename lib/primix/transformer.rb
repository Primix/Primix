module Primix
  class Transformer
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def transform!
      data
    end
  end
end
