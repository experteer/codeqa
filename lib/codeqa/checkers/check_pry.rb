require 'codeqa/checkers/pattern_checker'

module Codeqa
  module Checkers
    class CheckPry < PatternChecker
      def name
        "pry"
      end

      def hint
        "Leftover binding.pry found, please remove it."
      end

      def self.check?(sourcefile)
        sourcefile.attributes['language'] == 'ruby'
      end

    private

      PATTERN = 'binding.pry'
      def error_msg(match)
        "binding.pry found, please remove it."
      end
    end
  end
end
