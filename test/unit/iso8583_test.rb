
class WilliamMessage < ISO8583::Message
  include ISO8583
  mti_format N, :length => 4
  mti 200, "Authorization Request Acquirer Gateway"
  bmp  3  , "Processing Code"      , N          , :length =>  6
  bmp  4  , "Amount (Transaction)" , N          , :length => 12
  bmp  7  , "Amount (Transaction)" , N          , :length => 10
  bmp  11 , "Amount (Transaction)" , N          , :length => 6
  bmp  12 , "Amount (Transaction)" , N          , :length => 6
  bmp  13 , "Amount (Transaction)" , N          , :length => 4
  bmp  22 , "Amount (Transaction)" , N          , :length => 3
  bmp  32 , "Amount (Transaction)" , LLVAR_N
  bmp  35 , "Amount (Transaction)" , LLVAR_N
  bmp  41 , "Amount (Transaction)" , ANS        , :length => 8
  bmp  42 , "Amount (Transaction)" , ANS        , :length => 15
  bmp  45 , "Amount (Transaction)" , LLVAR_ANS
  bmp  48 , "Amount (Transaction)" , LLLVAR_ANS
  bmp  49 , "Amount (Transaction)" , AN         , :length => 3
  bmp  55 , "Amount (Transaction)" , LLLVAR_ANS
  bmp  61 , "Amount (Transaction)" , LLLVAR_ANS
end

#004 Amount (Transaction) : 600
#007 Amount (Transaction) : 608201250
#011 Amount (Transaction) : 55
#012 Amount (Transaction) : 171250

class DeviceISO8583Test < DaFunk::Test.case
  def setup
    @str = "02003238040120C98208003000000000000600060820125000005517125006080511100000001941379999701163750703=160320100190277164640000061100040000000000448 !'#$%&'()0123456789@ABCDEFGHIPQRSTUVWXY`abcdefg008003002019862705A0899997011637507039F02060000000006009F03060000000000009F1A020076950500804080005F2A0209869A031506089C01009F3704F6164711820258009F360200629F10200FA5F1A078F0000000000000000000010F0108520000000000000000000000009F260881CEEAA12263D32F9F2701809F0607A09900000010109F3403410302102001008EL0107SC002020000000002311315669050040160000000000003.3100500800000611006020000000000000INGENICO"
    @iso = WilliamMessage.parse(@str, true)
  end

  def test_bmp_3
    assert_equal @iso[3], 3000
  end

  def test_bmp_4
    assert_equal @iso[4], 600
  end

  def test_bmp_7
    assert_equal @iso[7], 608201250
  end

  def test_bmp_11
    assert_equal @iso[11], 55
  end

  def test_bmp_12
    assert_equal @iso[12], 171250
  end
end

