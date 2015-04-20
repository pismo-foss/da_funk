
class ParamsDatTest < DaFunk::Test.case
  def test_params_dat_not_nil_file
    assert_equal false, Device::ParamsDat.file.nil?
  end

  def test_params_dat_initialize_calling_file
    assert Device::ParamsDat.file.hash.is_a? Hash
  end
end

