class Device
  class EMVTable
    FILENAME = "./emv/emv_acquirer_aids.dat"

    include Device::Helper

    class << self
      attr_accessor :rows, :file
    end

    def self.load(acquirer_id)
      filepath  = FILENAME.gsub("_aids", "_aids_#{rjust(acquirer_id, 2, "0")}")
      self.file = FileDb.new(filepath, {})
      self.rows = []
      self.file.hash do |key,value|
        self.rows << EMVRow.new(value)
      end
      self.rows
    end

    def self.pkis
    end

    def self.apps
      self.rows.select {|row| row.emv? }
    end

    def self.apps
      self.rows.select {|row| row.pki? }
    end
  end
end

