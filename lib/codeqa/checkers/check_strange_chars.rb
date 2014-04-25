require 'codeqa/checkers/pattern_checker'

module Codeqa
  module Checkers
    class CheckStrangeChars < PatternChecker
      def self.check?(sourcefile)
        sourcefile.text?
      end

      def name
        "strange chars"
      end

      def hint
        "The file contains a tab or form feed. Remove them."
      end

    private

      PATTERN = /(\x09|\x0c)/
      def error_msg(line, line_number, pos)
        strangeness = (line[pos] == "\x09" ? 'TAB x09' : 'FORM FEED x0C')
        "#{strangeness} at line #{line_number} column #{pos + 1}"
      end
    end
  end
end
