
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
      libs.each do |file|
        require file
      end
    end
  end

  module CRuby
    def case
      engine::TestCase
    end

    def engine
      Test::Unit
    end

    def run; end

    def setup
      require 'fileutils'
      require 'test/unit' if ENV["RUBY_PLATFORM"] != "mruby"

      libs.each do |file|
        require file
      end
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

    def self.configure
      yield self if block_given?

      @root_path ||= File.dirname("./")
      @libs      ||= FileList[File.join(root_path, 'lib/**/*.rb')]
      @tests     ||= FileList[File.join(root_path, 'lib/**/*test.rb')]

      self.setup
    end
  end
end
