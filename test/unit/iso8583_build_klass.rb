
class MessageA < ISO8583::Message
  include ISO8583
  mti_format N, :length => 4

  mti 800, ""
  mti 810, ""

  bmp 1  , "" , N   , :length => 128
  bmp 7  , "" , N   , :length => 10
  bmp 11 , "" , N   , :length => 6
  bmp 12 , "" , N   , :length => 6
  bmp 13 , "" , N   , :length => 4
  bmp 41 , "" , ANS , :length => 8
  bmp 42 , "" , ANS , :length => 15
  bmp 70 , "" , N   , :length => 3
end

class DeviceISO8583BuildKlassTest < DaFunk::Test.case
  def setup
    @iso_a = MessageA.new 800
    @klass = ISO8583::FileParser.build_klass([ISO8583::N, {length: 4}], {800 => ""}, "./shared/bitmap.dat")
    @iso_b = @klass.new 800
  end

  def test_compare
    @iso_a[7]  = @iso_b[7]  = 201175436
    @iso_a[11] = @iso_b[11] = 2
    @iso_a[12] = @iso_b[12] = 175436
    @iso_a[13] = @iso_b[13] = 201
    @iso_a[41] = @iso_b[41] = "00009815"
    @iso_a[42] = @iso_b[42] = "636500050001800"
    @iso_a[70] = @iso_b[70] = 1

    assert_equal @iso_a.to_b, @iso_b.to_b
  end

  def test_parse_from_build_klass
    iso = "08100038000002401004000043005016020300636500050001800924F7E771BC0F3C20690090020306376550063765599SS23S0EE0N00006043230060432399SS03S0FE0N0000"
    @klass.mti 810, ""
    assert_equal @klass.parse(iso, true)[42], "636500050001800"
  end

  def test_128_bitmap
    message  = "0400B238060020C18008000000400000000400300000000000200009081659230000081659230908051003335413330000000000=1412601079360805GT006010012000006010001039005033295AFB93D534AFFCB0000000000000000986113001008GP0102CW002020000000000000680031310030260000000000800076          0040040.00005003PAX006004s9200070062.4.620200000006090816443200000000000000000000000070030012"
    klass_gp = ISO8583::FileParser.build_klass([ISO8583::N, {length: 4}], {400 => ""}, "./shared/bitmap_gp.dat")

    iso = klass_gp.new 400
    iso[  3] = "003000"
    iso[  4] = "000000002000"
    iso[  7] = "0908165923"
    iso[ 11] = "000008"
    iso[ 12] = "165923"
    iso[ 13] = "0908"
    iso[ 22] = "051"
    iso[ 23] = "003"
    iso[ 35] = "5413330000000000=1412601079360805"
    iso[ 41] = "GT006010"
    iso[ 42] = "012000006010001"
    iso[ 48] = "005033295AFB93D534AFFCB0000000000000000"
    iso[ 49] = "986"
    iso[ 61] = "001008GP0102CW002020000000000000680031310030260000000000800076          0040040.00005003PAX006004s9200070062.4.62"
    iso[ 90] = "020000000609081644320000000000000000000000"
    iso[126] = "0030012"

    assert_equal message, iso.to_b
  end
end

