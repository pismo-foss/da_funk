class Array
  def to_json
    JSON::stringify(self)
  end
end

