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
        sourcefile.attributes['text'] == true
      end

    private

      PATTERN = /^<<<<<<<|^>>>>>>>|^=======$/m
      def error_msg(match)
        "conflict leftovers, please merge properly"
      end
    end
  end
end
