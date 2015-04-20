
class FileDbTest < DaFunk::Test.case
  def test_create
    file_name = "test_create.dat"
    assert_equal false, File.exists?(file_name)
    assert FileDb.new(file_name, Hash.new).hash.is_a? Hash
  end

  def test_define_unset_value
    file = FileDb.new("test_define_unset_value.dat", {})
    file["unknown"] = "any"
    assert_equal "any", file["unknown"]
  end
end
