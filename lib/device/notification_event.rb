class Device
  class NotificationEvent
    attr_reader :values, :coalesce, :ltime, :payload, :name, :event, :message, :value, :body, :callback, :parameters

    def initialize(values)
      @values = values
      parse(values)
    end

    def type
      @event
    end

    private
    def parse(values)
      @coalesce = values["Coalesce"]
      @ltime    = values["LTime"]
      @payload  = values["Payload"]
      @name     = values["Name"]
      @event    = values["Event"]

      @message  = payload.gsub('=>', ' : ')
      @value    = JSON.parse(message)
      @body     = value["Body"]

      @callback, *@parameters = @body.to_s.split(",")
    end
  end
end
