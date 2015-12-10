class String
  def to_mask(mask_string)
    mask_clean = mask_string.chars.reject{|ch| ch.match(/[^0-9A-Za-z]/) }.join

    str = mask_string.chars.map{|s| s.match(/[0-9A-Za-z]/) ? "%s" : s }.join
    str % self.ljust(mask_clean.size, " ").chars
  end

  def chars
    self.split("")
  end
end

