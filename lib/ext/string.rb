class String
  def to_mask(mask_string)
    mask_clean = mask_string.chars.reject{|ch| ch.match(/[^0-9A-Za-z]/) }.join

    str = mask_string.chars.map{|s| s.match(/[0-9A-Za-z]/) ? "%s" : s }.join
    str % self.ljust(mask_clean.size, " ").chars
  end

  def chars
    self.split("")
  end

  def integer?
    return true if self[0] == "0"
    !!Integer(self)
  rescue ArgumentError => e
    if e.message[-19..-1] == "too big for integer"
      begin
        return self.to_i.to_s.size == self.size
      rescue
        false
      end
    end
    return false
  end
end

