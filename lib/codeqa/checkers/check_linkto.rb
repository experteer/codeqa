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
        sourcefile.attributes['text'] == true
      end

    private

      PATTERN = /<% link_to.* do.*%>/
      def error_msg(match)
        "#{match.size} line(s) of old style block link_to"
      end
    end
  end
end
