require 'pathname'
module Codeqa
  CODEQA_HOME = Pathname.new(File.join(File.dirname(__FILE__), '..')).realpath

  def self.root
    CODEQA_HOME
  end

  def self.install(root='.')
    require 'fileutils'
    git_root = "#{root}/.git"
    if File.exist?(git_root)
      pre_commit_path = File.join(git_root, 'hooks', 'pre-commit')
      if File.exist?(pre_commit_path)
        $stdout.puts "moving away the old pre-commit hook -> pre-commit.bkp"
        FileUtils.mv(pre_commit_path,
                     File.join(git_root, 'hooks', 'pre-commit.bkp'),
                     :force => true)
      end
      pre_commit_template_path = File.join(File.expand_path(File.dirname(__FILE__)),
                                           'templates/pre-commit')
      $stdout.puts 'placing new pre-commit hook'
      FileUtils.cp(pre_commit_template_path, pre_commit_path)
      if new_ruby_version
        FileUtils.chmod('+x', pre_commit_path)
      else
        FileUtils.chmod(0755, pre_commit_path)
      end
      true
    else
      $stderr.puts "#{root} is not in a git root"
      false
    end
  end

  def self.check(filename, options={})
    options = { :silent_success => false, :silent => false }.merge(options)
    runner = self.runner(filename)
    if runner.success?
      $stdout.puts(runner.display_result) unless options[:silent_success] || options[:silent]
      true
    else
      $stderr.puts runner.display_result
      false
    end
  end

  def self.runner(filename)
    sourcefile = Codeqa::Sourcefile.new(filename)
    Codeqa::Runner.run(sourcefile)
  end

  def self.new_ruby_version
    @new_ruby_version ||= Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("1.9.0")
  end

  def self.config
    if Config.loaded?
      Config.instance
    else
      Config.load
    end
  end
  def self.register_checkers
    [Codeqa::Checkers::CheckErb,
     Codeqa::Checkers::CheckErbHtml,
     Codeqa::Checkers::CheckLinkto,
     Codeqa::Checkers::CheckRubySyntax,
     Codeqa::Checkers::RubocopLint,
     Codeqa::Checkers::CheckStrangeChars,
     Codeqa::Checkers::CheckUtf8Encoding,
     Codeqa::Checkers::CheckYard,
     Codeqa::Checkers::CheckConflict,
     Codeqa::Checkers::CheckPry,
     Codeqa::Checkers::CheckRspecFocus
    ].each do |checker_klass|
      if Codeqa.config.enabled?(checker_klass) && checker_klass.available?
        Codeqa::Runner.register_checker(checker_klass)
      end
    end
  end
end

require "codeqa/version"
require 'codeqa/sourcefile'
require 'codeqa/checker'
require 'codeqa/check_errors'
require 'codeqa/runner'
require 'codeqa/runner_decorator'

require 'codeqa/config'
require 'codeqa/config_loader'

# load all files in checkers subfolder
Dir.glob(Codeqa.root.join('lib/codeqa/checkers/*.rb')) do |file|
  require "codeqa/checkers/#{file[%r{/([^/]+)\.rb}, 1]}"
end

Codeqa.register_checkers
