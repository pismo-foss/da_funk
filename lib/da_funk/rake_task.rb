#!/usr/bin/env rake

require 'rake'
require 'fileutils'
require 'rake/testtask'
require 'bundler/setup'

module DaFunk
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    attr_accessor :name, :libs, :tests, :tests_unit, :tests_integration, :root_path, :main_out, :test_out, :resources, :mrbc, :mruby, :out_path

    def initialize
      yield self if block_given?

      @libs              ||= FileList['lib/**/*.rb']
      @tests             ||= FileList['test/**/*test.rb']
      @tests_integration ||= FileList['test/integration/*test.rb']
      @tests_unit        ||= FileList['test/unit/*test.rb']
      @resources         ||= FileList['resources/**/*']
      @root_path         ||= File.expand_path("./")
      @name              ||= File.basename(root_path)
      @out_path          ||= File.join(root_path, "out", @name)
      @main_out          ||= File.join(out_path, "main.mrb")
      @test_out          ||= File.join(out_path, "test.mrb")
      @mruby             ||= "cloudwalk"
      @mrbc              ||= get_mrbc_bin

      define
    end

    def get_mrbc_bin
      if ENV["MRBC"]
        ENV["MRBC"]
      elsif system("type mrbc > /dev/null 2>&1 ")
        "env mrbc"
      elsif system("type cloudwalk > /dev/null 2>&1 ")
        "env cloudwalk build"
      else
        puts "$MRBC isn't set or mrbc/cloudwalk isn't on $PATH"
        exit 0
      end
    end

    def execute_tests(files)
      all_files = FileList["test/test_helper.rb"] + libs + files + [File.join(File.dirname(__FILE__), "..", "..", "utils", "command_line_platform.rb")] + [File.join(File.dirname(__FILE__), "..", "..", "utils", "test_run.rb")]
      if sh("#{mrbc} -o #{test_out} #{all_files.uniq}")
        sh("#{mruby} #{File.join(out_path, "test.mrb")}")
      end
    end

    def define
      namespace @name.to_sym do
        task :resources do
          resources.each do |file|
            FileUtils.cp(file, out_path) if File.file?(file)
          end
        end

        desc "Compile app to mrb"
        task :build => :resources do
          FileUtils.mkdir_p out_path

          Bundler.load.specs.each do |gem|
            sh "cp #{File.join(gem.full_gem_path, "out", gem.name)}.mrb #{out_path}/#{gem.name}.mrb" if File.exists? "#{File.join(gem.full_gem_path, "out", gem.name)}.mrb"
          end

          sh "#{mrbc} -o #{main_out} #{libs} "
        end

        namespace :mtest do
          task :setup do
            ENV["RUBY_PLATFORM"] = "mruby"

            FileUtils.rm_rf File.join(root_path, "out")
            FileUtils.mkdir_p out_path

            Bundler.load.specs.each do |gem|
              sh "cp #{File.join(gem.full_gem_path, "out", gem.name)}.mrb #{out_path}/#{gem.name}.mrb" if File.exists? "#{File.join(gem.full_gem_path, "out", gem.name)}.mrb"
            end
          end

          desc "Run unit test on mruby"
          task :unit => "#{@name}:mtest:setup" do
            execute_tests(tests_unit)
          end

          desc "Run integration test on mruby"
          task :integration => "#{@name}:mtest:setup" do
            execute_tests(tests_integration)
          end

          desc "Run all test on mruby"
          task :all => "#{@name}:mtest:setup" do
            execute_tests(tests)
          end
        end

        desc "Clobber/Clean"
        task :clean do
          FileUtils.mkdir_p File.join(root_path, "out")
          FileUtils.rm_rf main_out
        end
      end
      task :default => "#{@name}:build"
    end
  end
end
