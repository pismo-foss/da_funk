
class StringTest < DaFunk::Test.case
  def test_to_mask_number
    assert_equal "(12) 341-234", "12341234".to_mask("(99) 999-999")
  end

  def test_to_mask_letters
    assert_equal "(12) 341-234", "12341234".to_mask("(99) 999-999")
  end

  def test_to_mask_alpha
    assert_equal "(12) ac34-123", "12ac341234".to_mask("(99) 9AAA-999")
  end
end

