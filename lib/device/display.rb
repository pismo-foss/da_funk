class Device
  class Display
    def self.adapter
      Device.adapter::Display
    end

    # Same as print, but add "\\n" at end of print
    #
    # @param buf [String] Text to be printed.
    # @param row [Fixnum] Row to start display.
    # @param column [Fixnum] Column to start display.
    # @return [NilClass] nil.
    def self.puts(buf, row = nil, column = nil)
      self.print("#{buf}\n", row, column)
    end

    # Display buffer
    #
    # @param buf [String] Text to be printed.
    # @param row [Fixnum] Row to start display.
    # @param column [Fixnum] Column to start display.
    # @return [NilClass] nil.
    def self.print(buf, row = nil, column = nil)
      if row.nil? && column.nil?
        print(buf)
      else
        print_line(buf, row, column)
      end
    end

    # Display bitmap
    #
    # @param path [String] path
    # @param row [Fixnum] Row to start display.
    # @param column [Fixnum] Column to start display.
    # @return [NilClass] nil.
    def self.print_bitmap(path, row = 0, column = 0)
      raise(File::FileError, path) unless File.exists?(path)
      adapter.display_bitmap(path, row, column)
    end

    # Clean display
    #
    # @param line [Fixnum] Line to clear
    def self.clear(line = nil)
      if line.nil?
        adapter.clear
      else
        adapter.clear_line line
      end
    end
  end
end
