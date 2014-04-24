require 'codeqa/checkers/pattern_checker'

module Codeqa
  module Checkers
    class CheckRspecFocus < PatternChecker
      def name
        "rspec-focus"
      end

      def hint
        "Leftover binding.pry found, please remove it."
      end

      def self.check?(sourcefile)
        sourcefile.attributes['spec'] == true
      end

    private

      PATTERN = ':focus'
      def error_msg(match)
        ":focus found in specs"
      end
    end
  end
end
