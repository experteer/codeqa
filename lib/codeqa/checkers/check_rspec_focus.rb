require 'codeqa/checkers/pattern_checker'

module Codeqa
  module Checkers
    class CheckRspecFocus < PatternChecker
      def name
        "rspec-focus"
      end

      def hint
        "Leftover :focus in spec found, please remove it."
      end

      def self.check?(sourcefile)
        sourcefile.spec?
      end

    private

      def self.pattern
        @pattern ||= /:focus/
      end
      def error_msg(_line, line_number, _pos)
        ":focus in line #{line_number}"
      end
    end
  end
end
