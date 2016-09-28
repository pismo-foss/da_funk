
class DaFunkStructTest < DaFunk::Test.case
  def setup
    @klass = DaFunk::Struct.klass(:a, :b, :c)
    @obj   = @klass.call(10,20,30)
  end

  def test_struct
    assert_equal 10, @obj.a
    assert_equal 20, @obj.b
    assert_equal 30, @obj.c
  end

  def test_struct_nil
    @obj   = @klass.call
    assert_nil @obj.a
    assert_nil @obj.a
    assert_nil @obj.b
  end
end
