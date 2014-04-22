require 'erb'
module Codeqa
  module Checkers
    class CheckConflict < Checker
      LEFTOVER_PATTERN = /^<<<<<<<|^>>>>>>>|^=======$/m

      def name
        "conflict"
      end

      def hint
        "Remove the lines which are beginning with <<<<<<< or >>>>>>> or =======."
      end

      def self.check?(sourcefile)
        sourcefile.attributes['text'] == true
      end

      def check
        leftovers = sourcefile.content.match(LEFTOVER_PATTERN)
        if leftovers
          errors.add(nil, "conflict leftovers, please merge properly")
        end
      end
    end
  end
end
