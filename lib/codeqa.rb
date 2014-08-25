require 'pathname'
module Codeqa
  CODEQA_HOME = Pathname.new(File.join(File.dirname(__FILE__), '..')).realpath

  class << self
    def root
      CODEQA_HOME
    end

    def install(root='.')
      require 'fileutils'
      git_root = Pathname.new "#{root}/.git"
      if File.exist?(git_root)
        pre_commit_path = git_root.join 'hooks', 'pre-commit'
        if File.exist?(pre_commit_path)
          # $stdout.puts 'moving away the old pre-commit hook -> pre-commit.bkp'
          FileUtils.mv(pre_commit_path,
                       git_root.join('hooks', 'pre-commit.bkp'),
                       :force => true)
        end
        pre_commit_template_path = Codeqa.root.join('lib', 'templates', 'pre-commit')
        # $stdout.puts 'placing new pre-commit hook'
        FileUtils.cp(pre_commit_template_path, pre_commit_path)
        FileUtils.chmod('+x', pre_commit_path)
        true
      else
        # $stderr.puts "#{root} is not in a git root"
        false
      end
    end

    def check(filename, options={})
      options = { :silent_success => false, :silent => false }.merge(options)
      runner = runner(filename)
      if runner.success?
        $stdout.puts(runner.display_result) unless options[:silent_success] || options[:silent]
        true
      else
        $stderr.puts runner.display_result unless options[:silent]
        false
      end
    end

    def runner(filename)
      sourcefile = Codeqa::Sourcefile.new(filename)
      Codeqa::Runner.run(sourcefile)
    end

    def register_checkers
      Codeqa::Runner.reset_checkers
      configuration.enabled_checker.each do |checker|
        begin
          checker_klass = Codeqa::Checkers.const_get(checker)
          next unless checker_klass.available?
          Codeqa::Runner.register_checker checker_klass
        rescue
          "checker <#{checker}> not known"
        end
      end
    end
  end
end

require 'codeqa/version'
require 'codeqa/sourcefile'
require 'codeqa/checker'
require 'codeqa/check_errors'
require 'codeqa/runner'
require 'codeqa/runner_decorator'
require 'codeqa/utils/erb_sanitizer'

require 'codeqa/configuration'

# load all files in checkers subfolder
Dir.glob(Codeqa.root.join('lib/codeqa/checkers/*.rb')) do |file|
  require "codeqa/checkers/#{file[%r{/([^/]+)\.rb}, 1]}"
end

Codeqa.register_checkers
