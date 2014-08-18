require 'stringio'

module Codeqa
  module Checkers
    class CheckYard < Checker
      def self.check?(sourcefile)
        sourcefile.ruby? && !(sourcefile.filename =~ /^(test|spec)/)
      end
      def self.available?
        yard?
      end

      def self.io
        @@io ||= StringIO.new
      end

      def name
        'yard'
      end

      def hint
        'Yard gives us some warnings on the file you can run <yardoc filename> to check yourself.'
      end

      def check
        if self.class.yard?
          ::YARD.parse_string(sourcefile.content) # let yard parse the file content
          io.rewind # rewind the io
          message = io.read
          warnings = message.match(/\A\[warn\]: /)
          errors.add(nil, message.gsub(/\(stdin\)/, sourcefile.filename)) if warnings
        end
      ensure
        io.reopen # clear the message for the next file
      end

    private

      def io
        self.class.io
      end

      def self.yard?
        @loaded ||= begin
                      require 'yard'
                      ::YARD::Logger.instance(io) # replace YARD logger with io
                      true
                    rescue LoadError
                      puts 'yard not installed'
                      false
                    end
      end
    end
  end
end
