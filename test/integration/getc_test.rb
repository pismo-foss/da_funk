
class GetcTest < DaFunk::Test.case
  def test_getc
    assert_equal "a", getc(1000)
  end
end
