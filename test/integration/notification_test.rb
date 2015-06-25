
class NotificationTest < DaFunk::Test.case
  def test_notification
    Device::Setting.to_staging!
    Device::Setting.company_name = "pc1"
    Device::Setting.logical_number = "0101"
    Device::Notification.setup
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

  def test_notification_50_checks
    Device::Setting.to_staging!
    Device::Setting.company_name = "pc1"
    Device::Setting.logical_number = "0101"
    Device::Notification.setup
    notification = Device::Notification.new

    50.times do
      notification.check
      sleep 2
    end

    notification.close
    assert notification.closed?
  end
end

