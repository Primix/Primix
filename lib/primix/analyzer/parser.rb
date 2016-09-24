module Primix
  module Parser

    attr_accessor :tokens
    attr_accessor :current_index
    attr_accessor :stack

    def initialize(tokens)
      @tokens = tokens
      @stack  = []
      @current_index = 0
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
    end

    def reduce_grammar
      @stack.size.tap do |before|
        reduce_to_type
        reduce_to_key_type
        reduce_to_key_types
        reduce_to_var
        reduce_to_enum
        recude_to_method
        reduce_to_method_partial

        if @stack.size != before
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
      reduce([:token, :colon, :TYPE], :KEY_TYPE, [:reduce])
    end

    def reduce_to_type
      reduce_with_look_back_and_ahead([:colon, :token], :TYPE, 1, [:question, :bang, :reduce])
      reduce_with_look_back_and_ahead([:reduce, :token], :TYPE, 1, [:question, :bang, :reduce])
      reduce([:token, :question],           :TYPE)
      reduce([:token, :bang],               :TYPE)
      reduce([:token, :reduce, :TYPE],      :TYPE)
      reduce([:TYPE, :reduce, :TYPE],       :TYPE)
      reduce([:left_paranthesis, :TYPE, :right_paranthesis],            :TYPE, [:question, :bang])
      reduce([:left_paranthesis, :TYPE, :right_paranthesis, :question], :TYPE)
      reduce([:left_paranthesis, :TYPE, :right_paranthesis, :bang],     :TYPE)
    end

    def reduce(tokens, type, *lookahead)
      reduce_with_look_back_and_ahead(tokens, type, 0, lookahead.flatten)
    end

    def reduce_with_look_back_and_ahead(tokens, type, lookback = 0, lookahead = [])
      return if lookahead.count > 0 && next_token && lookahead.include?(next_token.type)
      count = tokens.size
      case token_in_stack_types.last count
      when tokens
        need_replaced = count-lookback
        stack[-need_replaced..-1] = Node.new(type, stack.last(need_replaced))
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
