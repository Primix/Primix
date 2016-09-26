module Primix
  class Analyzer
    module AST
      require_relative 'ast/base'
      require_relative 'ast/type'
      require_relative 'ast/enum'
      require_relative 'ast/method'
      require_relative 'ast/key_type'
      require_relative 'ast/key_types'
      require_relative 'ast/var_decl'
      require_relative 'ast/let_decl'
    end
  end
end
