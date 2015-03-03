
class ParamsDatTest < DaFunk::Test.case
  def test_parse_apps
    Device::Setting.environment = "staging"
    Device::Setting.host = Device::Setting::HOST_STAGING
    Device::Setting.company_name = "pc1"
    Device::Setting.logical_number = "1410"
    Device::ParamsDat.update_apps
    Device::ParamsDat.application_menu
  end
end
