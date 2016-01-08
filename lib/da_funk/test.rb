
module DaFunk
  module MRuby
    def case
      engine::TestCase
    end

    def engine
      MTest::Unit
    end

    def run
      engine.new.run
    end

    def platform
      :mruby
    end
  end

  class Test
    class << self
      attr_accessor :root_path, :libs, :tests, :logical_number, :serial, :name,
        :brand, :model, :battery
      include DaFunk::MRuby
    end

    def self.mruby?
      platform == :mruby
    end

    def self.configure
      yield self if block_given?

      @root_path      ||= File.dirname("./")
      @serial         ||= "1111111111"
      @logical_number ||= "00001"
      @name           ||= "main"
      @brand          ||= "test"
      @model          ||= "test"
      @battery        ||= "100"
    end
  end
end

