require 'tempfile'
module Codeqa
  class Checker
    def initialize(sourcefile)
      @errors = CheckErrors.new
      @sourcefile = sourcefile
    end

    attr_reader :sourcefile

    def success?
      @errors.success?
    end

    def errors?
      !success?
    end

    def self.check?(sourcefile)
      raise "implement check?"
    end

    def check
      raise "implement check"
    end

    attr_reader :errors

  private

    def with_existing_file(content=sourcefile.content)
      if sourcefile.exist? && sourcefile.content == content
        yield sourcefile.filename
      else
        Tempfile.open("codeqa") do |tmpfile|
          tmpfile.write(content)
          tmpfile.flush
          tmpfile.rewind
          yield tmpfile.path
        end
      end
    end
  end
end
