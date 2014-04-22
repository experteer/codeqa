require 'erb'
module Codeqa
  module Checkers
    class CheckLinkto < Checker
      OLD_STYLE_LINKTO_PATTERN = /<% link_to.* do.*%>/

      def name
        "link_to"
      end

      def hint
        "<% link_to ... do ... %> detected add an '=' after the <%"
      end

      def self.check?(sourcefile)
        sourcefile.attributes['text'] == true
      end

      def check
        leftovers = sourcefile.content.match(OLD_STYLE_LINKTO_PATTERN)
        if leftovers
          errors.add(nil, "#{leftovers.size} line(s) of old style block link_to")
        end
      end
    end
  end
end
