
class EMVRowTest < DaFunk::Test.case
  def setup
    @pki_hash = {:reserved=>"00", :ca_public_key_index=>"07", :identification=>"2", :acquirer_id=>"04", :ca_public_key_modulus_byte_length=>"144", :rid=>"A000000003", :working_key=>"00000000000000000000000000000000", :ca_public_key_modulus=>"A89F25A56FA6DA258C8CA8B40427D927B4A1EB4D7EA326BBB12F97DED70AE5E4480FC9C5E8A972177110A1CC318D06D2F8F5C4844AC5FA79A4DC470BB11ED635699C17081B90F1B984F12E92C1C529276D8AF8EC7F28492097D8CD5BECEA16FE4088F6CFAB4A1B42328A1B996F9278B0B7E3311CA5EF856C2F888474B83612A82E4E00D0CD4069A6783140433D50725F0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", :status_check_sum=>"1", :ca_public_key_check_sum=>"B4BC56CC4E88324932CBC643D6898F6FE593B17200000000", :master_key_index=>"00", :ca_public_key_exponent_byte_length=>"1", :ca_public_key_exponent=>"030000", :index=>"01", :length=>"611"}
    @emv_hash = {:tdol=>"0000000000000000000000000000000000000000", :ddol=>"9F37049F47018F019F3201000000000000000000", :authorization_code_offline_approved=>"Y1", :authorization_code_offline_declined=>"Z1", :terminal_action_code_denial=>"0000000000", :terminal_action_code_online=>"0000000000", :terminal_floor_limit=>"0000C350", :reserved=>"00000000000000000000000000000000", :authorization_code_unable_online_offline_approved=>"Y3", :authorization_code_unable_online_offline_declined=>"Z3", :label=>"SMARTCON iEMV ON", :index=>"99", :length=>"284", :identification=>"1", :acquirer_id=>"04", :aid_length=>"07", :application_version_number_2=>"0084", :application_version_number_3=>"0000", :terminal_country_code=>"076", :transaction_currency_code=>"986", :aid=>"AAA00000010103000000000000000000", :application_type=>"01", :table_type=>"03", :application_version_number_1=>"008C", :terminal_capabilities=>"E0E8C0", :terminal_additional_capabilities=>"6000F0F000", :terminal_type=>"22", :terminal_action_code_default=>"5000000000", :transaction_currency_exponent=>"2", :merchant_identifier=>"000000000000001", :merchant_category_code=>"0100", :terminal_identification=>"49000076"}
    @emv = "2841049907AAA0000001010300000000000000000001SMARTCON iEMV ON03008C008400000769862000000000000001010049000076E0E8C06000F0F000225000000000000000000000000000000000C3500000000000000000000000000000000000000000000000000000000000000000000000009F37049F47018F019F3201000000000000000000Y1Z1Y3Z3"
    #@pki = "61120401A00000000307001030000144A89F25A56FA6DA258C8CA8B40427D927B4A1EB4D7EA326BBB12F97DED70AE5E4480FC9C5E8A972177110A1CC318D06D2F8F5C4844AC5FA79A4DC470BB11ED635699C17081B90F1B984F12E92C1C529276D8AF8EC7F28492097D8CD5BECEA16FE4088F6CFAB4A1B42328A1B996F9278B0B7E3311CA5EF856C2F888474B83612A82E4E00D0CD4069A6783140433D50725F00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001B4BC56CC4E88324932CBC643D6898F6FE593B172000000000000000000000000000000000000000000"
    @pki = "61120408AAA0000001F1003010001176D9E36579B94A5FF3150B64643D85C06E6E9F0682BE56CDD69FCB053913495BDBC327DA3CAC0EA2A0DA1D55DF7C66A0C6F6A9039FA72753C434F4A63BED54062799DF1F6D6E1F315A8F4109721126E11F4FF562C18A4AE6A4D9F0C2A5C2A8E44D6A98628C7E25290584F0F3D9ECE6566FDB7688596649BEC89A1CBC8BBED075538300D0D83FF8755E1CE73668908C387E14ACDF0F9F1DE436A5A07308812D6AE3A16170EDF2522B36FBE94358F50C0B6900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000014dddd1d9b9a3b2eeace63a5ba9dd6f4441ce10af000000000000000000000000000000000000000000"
  end

  def test_row_pki_type
    assert_equal :pki, Device::EMVRow.new(@pki).type
  end

  def test_row_emv_type
    assert_equal :emv, Device::EMVRow.new(@emv).type
  end

  def test_row_emv
    row = Device::EMVRow.new(@emv)
    assert_equal @emv_hash, row.hash
  end

  def test_row_pki
    row = Device::EMVRow.new(@pki)
    assert_equal @pki_hash, row.hash
  end

  def test_row_access
    row = Device::EMVRow.new(@emv)
    assert_equal @emv_hash[:merchant_identifier], row.merchant_identifier
  end
end
