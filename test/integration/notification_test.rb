
class NotificationTest < DaFunk::Test.case
  def test_notification
    Device::Setting.company_name = "pc1"
    Device::Setting.logical_number = "0101"
    notification = Device::Notification.new
    assert_equal nil, notification.check
    notification.check
    notification.check
    assert notification.close
    assert notification.closed?
    notification = Device::Notification.new
    assert_equal nil, notification.check
    notification.check
    notification.check
    notification.close
    assert notification.closed?
  end
end

