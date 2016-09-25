module Primix
  class Analyzer
    class Parser
      require_relative 'analyze_model/token'
      require_relative 'analyze_model/node'
      require_relative 'ast'

      include Analyzer::AST

      attr_accessor :identifiers
      attr_accessor :current_index
      attr_accessor :stack
      attr_accessor :tokens
      attr_accessor :has_reduced

      def initialize(tokens)
        @tokens = tokens
        @current_index = 0
        @stack = []
      end

      def parse!
        while current_index < tokens.size
          shift_token
          reduce_grammar
        end
        @stack
      end

      def shift_token
        stack << tokens[@current_index]
        @current_index += 1
        p "shift: #{stack.map { |s| s.type }}"
      end

      def reduce_grammar
        @has_reduced = false
        @stack.size.tap do |before|
          reduce_to_type
          reduce_to_key_type
          reduce_to_key_types
          reduce_to_var
          # reduce_to_enum
          # recude_to_method
          # reduce_to_method_partial

          if has_reduced
            p "reduce: #{token_in_stack_types}"
            reduce_grammar
          end
        end
      end

      def recude_to_method
        reduce([:METHOD_PARTIAL, :reduce, :TYPE], :METHOD)
        reduce([:METHOD_PARTIAL],                 :METHOD, :reduce)
        reduce([:modifier, :METHOD],              :METHOD)
      end

      def reduce_to_method_partial
        reduce([:func, :identifier, :l_paren, :KEY_TYPES, :r_paren], :METHOD_PARTIAL)
        reduce([:func, :identifier, :l_paren, :KEY_TYPE,  :r_paren], :METHOD_PARTIAL)
        reduce([:func, :identifier, :l_paren, :r_paren],             :METHOD_PARTIAL)
      end

      def reduce_to_enum
        reduce([:enum, :identifier], :ENUM, :colon)
        reduce([:enum, :KEY_TYPE],   :ENUM)
      end

      def reduce_to_var
        reduce([:var, :KEY_TYPE], VarDecl)
        reduce([:let, :KEY_TYPE], LetDecl)
        reduce([:modifier, :VAR_DECL], VarDecl)
        reduce([:modifier, :LET_DECL], LetDecl)
      end

      def reduce_to_key_types
        reduce([:KEY_TYPE, :comma, :KEY_TYPE],  KeyTypes)
        reduce([:KEY_TYPE, :comma, :KEY_TYPES], KeyTypes)
      end

      def reduce_to_key_type
        reduce([:identifier, :colon, :TYPE], KeyType, :reduce, :question, :bang)
      end

      def reduce_to_type
        reduce([:identifier],      Type) if token_in_stack_types.include?(:colon) || token_in_stack_types.include?(:reduce)
        reduce([:TYPE, :question], OptionalType)
        reduce([:TYPE, :bang],     NonNilOptionalType)
        reduce([:l_paren,  :TYPE, :r_paren],  WrappedType)
        reduce([:l_square, :TYPE, :r_square], ArrayType)
        reduce([:TYPE,     :reduce, :TYPE],   FunctionType)
        reduce([:l_square, :TYPE,   :colon, :TYPE, :r_square], HashType)
      end

      def reduce(tokens, kls, *lookahead)
        return if lookahead.count > 0 && next_token && lookahead.include?(next_token.type)
        return if has_reduced
        count = tokens.size
        case token_in_stack_types.last count
        when tokens
          stack[-count..-1] = kls.new(stack.last(count))
          @has_reduced = true
        end
      end

      def token_in_stack_types
        @stack.map { |t| t.type }
      end

      def next_token
        tokens[@current_index]
      end
    end
  end
end
