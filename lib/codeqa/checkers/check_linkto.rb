require 'codeqa/checkers/pattern_checker'

module Codeqa
  module Checkers
    class CheckLinkto < PatternChecker
      def name
        "link_to"
      end

      def hint
        "<% link_to ... do ... %> detected add an '=' after the <%"
      end

      def self.check?(sourcefile)
        sourcefile.text?
      end

    private

      PATTERN = /<% link_to.* do.*%>/
      def error_msg(_line, line_number, _pos)
        "old style block link_to in line #{line_number}"
      end
    end
  end
end