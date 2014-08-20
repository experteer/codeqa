require 'stringio'
require 'tempfile'
require 'forwardable'

module Codeqa
  class Checker
    extend ::Forwardable

    def initialize(sourcefile)
      @errors = CheckErrors.new
      @sourcefile = sourcefile
    end

    attr_reader :sourcefile
    attr_reader :errors
    def_delegators :@errors, :success?, :errors?

    def self.available?
      true
    end

  private

    def with_existing_file(content=sourcefile.content)
      if sourcefile.exist? && sourcefile.content == content
        yield sourcefile.filename
      else
        Tempfile.open('codeqa') do |tmpfile|
          tmpfile.write(content)
          tmpfile.flush
          tmpfile.rewind
          yield tmpfile.path
        end
      end
    end

    def capture
      $stdout, stdout = StringIO.new, $stdout
      $stderr, stderr = StringIO.new, $stderr
      result = yield
      [result, $stdout.string + $stderr.string]
    ensure
      $stdout = stdout
      $stderr = stderr
    end
  end
end
