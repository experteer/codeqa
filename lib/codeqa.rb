module Codeqa
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
end

require "codeqa/version"
require 'codeqa/sourcefile'
require 'codeqa/checker'
require 'codeqa/check_errors'
require 'codeqa/runner'
require 'codeqa/runner_decorator'

# load all files in checkers subfolder
Dir.glob('lib/codeqa/checkers/*.rb') do |file|
  require "codeqa/checkers/#{file[%r{/([^/]+)\.rb}, 1]}"
end

require 'codeqa/config'
require 'codeqa/config_loader'

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
  next unless checker_klass.available?
  Codeqa::Runner.register_checker(checker_klass) if Codeqa.config.enabled?(checker_klass)
end
