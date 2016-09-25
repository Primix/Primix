module Primix
  class Analyzer
    class Parser
      require 'primix/analyzer/analyzer_model/token'
      require 'primix/analyzer/analyzer_model/node'

      attr_accessor :tokens
      attr_accessor :current_index
      attr_accessor :stack
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
        # p "shift: #{stack.map { |s| s.type }}"
      end

      def reduce_grammar
        @has_reduced = false
        @stack.size.tap do |before|
          reduce_to_type
          reduce_to_key_type
          reduce_to_key_types
          reduce_to_var
          reduce_to_enum
          recude_to_method
          reduce_to_method_partial

          if has_reduced
            # p "reduce: #{token_in_stack_types}"
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
        reduce([:func, :token, :left_paranthesis, :KEY_TYPES, :right_paranthesis], :METHOD_PARTIAL)
        reduce([:func, :token, :left_paranthesis, :KEY_TYPE, :right_paranthesis],  :METHOD_PARTIAL)
        reduce([:func, :token, :left_paranthesis, :right_paranthesis],             :METHOD_PARTIAL)
      end

      def reduce_to_enum
        reduce([:enum, :token],    :ENUM, :colon)
        reduce([:enum, :KEY_TYPE], :ENUM)
      end

      def reduce_to_var
        reduce([:var, :KEY_TYPE], :VAR)
        reduce([:modifier, :VAR], :VAR)
      end

      def reduce_to_key_types
        reduce([:KEY_TYPE, :comma, :KEY_TYPE],  :KEY_TYPES)
        reduce([:KEY_TYPE, :comma, :KEY_TYPES], :KEY_TYPES)
      end

      def reduce_to_key_type
        reduce([:token, :colon, :TYPE], :KEY_TYPE, :reduce, :question, :bang)
      end

      def reduce_to_type
        reduce([:token],           :TYPE) if token_in_stack_types.include?(:colon) || token_in_stack_types.include?(:reduce)
        reduce([:TYPE, :question], :TYPE)
        reduce([:TYPE, :bang],     :TYPE)
        reduce([:left_paranthesis, :TYPE,   :right_paranthesis], :TYPE)
        reduce([:left_bracket,     :TYPE,   :right_bracket],     :TYPE)
        reduce([:TYPE,             :reduce, :TYPE],              :TYPE)
        reduce([:left_paranthesis, :TYPE,   :comma, :TYPE, :right_paranthesis], :TYPE)
      end

      def reduce(tokens, type, *lookahead)
        return if lookahead.count > 0 && next_token && lookahead.include?(next_token.type)
        return if has_reduced
        count = tokens.size
        case token_in_stack_types.last count
        when tokens
          stack[-count..-1] = Node.new(type, stack.last(count))
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
