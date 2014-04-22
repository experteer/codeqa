require 'iconv' unless Codeqa.new_ruby_version
require 'stringio'
module Codeqa
  module Checkers
    class CheckStrangeChars < Checker
      def self.check?(sourcefile)
        sourcefile.attributes['text'] == true
      end

      def name
        "strange chars"
      end

      def hint
        "The file contains a tab or form feed. Remove them."
      end

      def check
        strange = /(\x09|\x0c)/
        lineno = 1
        StringIO.open(sourcefile.content) do |fd|
          fd.readlines.each do |line|
            pos = (line =~ strange)
            if pos
              strangeness = ($1 == "\x09" ? 'TAB x09' : 'FORM FEED x0C')
              errors.add("#{lineno},#{pos + 1}", "#{strangeness} at line #{lineno} column #{pos + 1}")
            end
            lineno += 1
          end
        end
      end
    end
  end
end
