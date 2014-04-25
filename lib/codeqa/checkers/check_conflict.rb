require 'codeqa/checkers/pattern_checker'

module Codeqa
  module Checkers
    class CheckConflict < PatternChecker
      def name
        "conflict"
      end

      def hint
        "Remove the lines which are beginning with <<<<<<< or >>>>>>> or =======."
      end

      def self.check?(sourcefile)
        sourcefile.text?
      end

    private

      PATTERN = /^<<<<<<<|^>>>>>>>|^=======$/m
      def error_msg(_line, line_number, _pos)
        "conflict leftovers in line #{line_number}, please merge properly"
      end
    end
  end
end
