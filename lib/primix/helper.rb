class Array
  def compact(element)
    [].tap do |result|
      self.each_with_index { |item, index|
        result << item unless item == element && item == self[index+1]
      }
    end
  end
end
