module Primix
  module Parser

    attr_reader :tokens

    def initialize(tokens)
      @tokens = tokens
    end
    def parse!
      method_modifiers = %w[static class @objc dynamic required]
      variable_modifiers = %w[weak lazy]
      access_modifiers = %w[public internal private open fileprivate]
      modifiers = method_modifiers + variable_modifiers + access_modifiers

    end
  end
end
