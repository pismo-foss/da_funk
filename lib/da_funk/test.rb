
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
      # TODO Scalone check this
      #libs.each do |file|
        #p file
        ##require file
      #end
    end

    def platform
      :mruby
    end
  end

  module CRuby
    def case
      engine::TestCase
    end

    def engine
      ::Test::Unit
    end

    def run; end

    def setup
      require 'fileutils'
      require 'test/unit'

      libs.each do |file|
        require file
      end
    end

    def platform
      :cruby
    end
  end

  class Test
    class << self
      attr_accessor :root_path, :libs, :tests

      if Object.const_defined?(:MTest)
        include DaFunk::MRuby
      else
        include DaFunk::CRuby
      end
    end

    def self.mruby?
      platform == :mruby
    end

    def self.cruby?
      platform == :cruby
    end

    # TODO Scalone Refactor tests/libs for mruby and cruby checking project configuration
    def self.configure
      yield self if block_given?

      @root_path ||= File.dirname("./")
      if self.cruby?
        @libs      ||= FileList[File.join(root_path, 'lib/**/*.rb')]
        @tests     ||= FileList[File.join(root_path, 'test/**/*test.rb')]
      end

      self.setup
    end
  end
end

