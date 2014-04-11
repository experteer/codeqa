module Codeqa
  def self.check(filename, options={})
    options={:silent_success => false, :silent => false}.merge(options)
    runner=self.runner(filename)
    if runner.success?
      $stdout.puts(runner.display_result) unless options[:silent_success] || options[:silent]
      true
    else
      $stderr.puts runner.display_result
      false
    end
  end

  def self.runner(filename)
    sourcefile=Codeqa::Sourcefile.new(filename)
    Codeqa::Runner.run(sourcefile)
  end

  def self.new_ruby_version
    @new_ruby_version ||= Gem::Version.new(RUBY_VERSION)>=Gem::Version.new("1.9.0")
  end
end

require "codeqa/version"
require 'codeqa/sourcefile'
require 'codeqa/checker'
require 'codeqa/check_errors'
require 'codeqa/runner'
require 'codeqa/runner_decorator'

require 'codeqa/checkers/check_conflict'
require 'codeqa/checkers/check_yard'
require 'codeqa/checkers/check_erb'
require 'codeqa/checkers/check_erb_html'
require 'codeqa/checkers/check_ruby_syntax'
require 'codeqa/checkers/check_utf8_encoding'
require 'codeqa/checkers/check_strange_chars'
require 'codeqa/checkers/check_linkto'

#Codeqa::Runner.register_checker(Codeqa::Checkers::CheckErb)
#Codeqa::Runner.register_checker(Codeqa::Checkers::CheckErbHtml)
Codeqa::Runner.register_checker(Codeqa::Checkers::CheckLinkto)
Codeqa::Runner.register_checker(Codeqa::Checkers::CheckRubySyntax)
Codeqa::Runner.register_checker(Codeqa::Checkers::CheckStrangeChars)
Codeqa::Runner.register_checker(Codeqa::Checkers::CheckUtf8Encoding)
Codeqa::Runner.register_checker(Codeqa::Checkers::CheckYard)
Codeqa::Runner.register_checker(Codeqa::Checkers::CheckConflict)