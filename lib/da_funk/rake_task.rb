#!/usr/bin/env rake

require 'rake'
require 'fileutils'
require 'rake/testtask'
require 'bundler/setup'

module DaFunk
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    attr_accessor :name, :libs, :tests, :root_path, :main_out, :test_out, :resources

    def initialize(name = :da_funk)
      @name = name

      yield self if block_given?

      @libs              ||= FileList['lib/**/*.rb']
      @tests             ||= FileList['lib/**/*test.rb']
      @tests_integration ||= FileList['lib/integration/*test.rb']
      @tests_unit        ||= FileList['lib/unit/*test.rb']
      @resources         ||= FileList['resources/**/*']
      @root_path         ||= File.dirname("./")
      @main_out          ||= File.join(root_path, "out", "main.mrb")
      @test_out          ||= File.join(root_path, "out", "test.mrb")

      define
    end

    def execute_tests(files)
      all_files = FileList["test/test_helper.rb"] + files + ["test/test_run.rb"]
      if sh("mrbc -o #{main_out} #{libs.uniq}") && sh("mrbc -o #{test_out} #{all_files.uniq}")
        sh("mruby -b out/test.mrb")
      end
    end

    def define
      namespace @name do
        task :check do
          if ENV["MRBC"].nil? && ! system("type mrbc > /dev/null 2>&1 ")
            puts "$MRBC isn't set or mrbc isn't on $PATH"
            exit 0
          end
        end

        task :resources do
          resources.each do |file|
            FileUtils.cp(file, File.join(root_path, "out/"))
          end
        end

        desc "Compile app to mrb"
        task :build => [:check, :resources] do
          FileUtils.mkdir_p File.join(root_path, "out")

          Bundler.load.specs.each do |gem|
            sh "cp #{File.join(gem.full_gem_path, "out", gem.name)}.mrb out/#{gem.name}.mrb" if File.exists? "#{File.join(gem.full_gem_path, "out", gem.name)}.mrb"
          end

          if ENV["MRBC"]
            sh "#{ENV["MRBC"]} -o #{main_out} #{libs} "
          else
            sh "env mrbc -o #{main_out} #{libs}"
          end
        end

        namespace :mtest do
          task :setup do
            ENV["RUBY_PLATFORM"] = "mruby"

            FileUtils.rm_rf File.join(root_path, "out")
            FileUtils.mkdir_p File.join(root_path, "out")

            Bundler.load.specs.each do |gem|
              sh "cp #{File.join(gem.full_gem_path, "out", gem.name)}.mrb out/#{gem.name}.mrb" if File.exists? "#{File.join(gem.full_gem_path, "out", gem.name)}.mrb"
            end
          end

          desc "Run unit test on mruby"
          task :unit => ["#{@name}:check", "#{@name}:mtest:setup"] do
            execute_tests(tests_unit)
          end

          desc "Run integration test on mruby"
          task :integration => ["#{@name}:check", "#{@name}:mtest:setup"] do
            execute_tests(tests_integration)
          end

          desc "Run all test on mruby"
          task :all => ["#{@name}:check", "#{@name}:mtest:setup"] do
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
