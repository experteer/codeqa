require "codeqa/version"
require 'codeqa/sourcefile'
require 'codeqa/checker'
require 'codeqa/check_errors'
require 'codeqa/runner'
require 'codeqa/runner_decorator'

require 'codeqa/check_conflict'
require 'codeqa/check_yard'
require 'codeqa/check_erb'
require 'codeqa/check_erb_html'
require 'codeqa/check_ruby_syntax'
require 'codeqa/check_utf8_encoding'

module Codeqa
  def self.check(filename, options={})
    options={:silent_success=>false,:silent=>false}.merge(options)
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
end