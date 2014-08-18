require 'codeqa/checkers/pattern_checker'

module Codeqa
  module Checkers
    class CheckPry < PatternChecker
      def name
        'pry'
      end

      def hint
        'Leftover binding.pry found, please remove it.'
      end

      def self.check?(sourcefile)
        sourcefile.ruby?
      end

    private

      def self.pattern
        @pattern ||= /binding\.pry/
      end
      def error_msg(_line, line_number, _pos)
        "binding.pry in line #{line_number}"
      end
    end
  end
end
