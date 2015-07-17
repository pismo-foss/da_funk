
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

  def test_notification_SHOW_MESSAGE
    $status = nil
    Device::Setting.to_staging!
    Device::Setting.company_name = "pc1"
    Device::Setting.logical_number = "0101"
    Device::Notification.setup
    NotificationCallback.new "SHOW_MESSAGE", :on => Proc.new { |message,datetime|
      $status = message
    }

    notification = Device::Notification.new

    puts "Must create message AAAA"
    time = Time.now + 60
    while(time > Time.now && $status.nil?) do
      notification.check
      sleep 2
    end
    assert_equal "AAAA", $status

    notification.close
    assert notification.closed?
  end
end

