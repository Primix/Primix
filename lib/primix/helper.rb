class Array
  def compact_with_element(element)
    [].tap do |result|
      self.each_with_index { |item, index|
        result << item unless item == element && item == self[index+1]
      }
    end
  end

  def remove_newlines_in_brace
    brace_level = 0
    [].tap do |result|
      self.each_with_index do |item, index|
        if item == "["
          brace_level += 1
        elsif item == "]"
          brace_level -= 1
        end
        next if brace_level >= 1 && item == "\n"
        result << item
      end
    end
  end
end
