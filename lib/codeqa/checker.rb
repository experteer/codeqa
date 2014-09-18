require 'stringio'
require 'tempfile'
require 'forwardable'
require 'codeqa/utils/check_errors'
require 'codeqa/utils/offense_collector'

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

    def with_existing_file(content = sourcefile.content)
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
  end
end
