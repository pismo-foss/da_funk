
class MessageA < ISO8583::Message
  include ISO8583
  mti_format N, :length => 4

  mti 800, ""

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
end

