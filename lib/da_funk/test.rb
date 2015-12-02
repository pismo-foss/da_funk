
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

    def setup
    end

    def platform
      :mruby
    end
  end

  class Test
    class << self
      attr_accessor :root_path, :libs, :tests, :logical_number, :serial, :name
      include DaFunk::MRuby
    end

    def self.mruby?
      platform == :mruby
    end

    def self.cruby?
      platform == :cruby
    end

    # TODO Scalone Refactor tests/libs for mruby and cruby checking project configuration
    # A good approach could be consider each test a runtime execution
    def self.configure
      yield self if block_given?

      @root_path      ||= File.dirname("./")
      @serial         ||= "1111111111"
      @logical_number ||= "00001"
      @name           ||= "main"
      if self.cruby?
        @libs      ||= FileList[File.join(root_path, 'lib/**/*.rb')]
        @tests     ||= FileList[File.join(root_path, 'test/**/*test.rb')]
      end

      self.setup
    end
  end
end

