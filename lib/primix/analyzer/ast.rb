module Primix
  class Analyzer
    module AST
      require_relative 'ast/base'
      require_relative 'ast/type'
      require_relative 'ast/enum'
      require_relative 'ast/value'
      require_relative 'ast/key_type'
      require_relative 'ast/var_decl'
      require_relative 'ast/let_decl'
      require_relative 'ast/method_decl'
      require_relative 'ast/constructor'
      require_relative 'ast/outer_key_type'
    end
  end
end
