require 'erb'
module Codeqa
  class CheckConflict < Checker
    LEFTOVER_PATTERN=/\A<<<<<<<|\A>>>>>>>|\A=======\Z/

    def name
      "conflict"
    end

    def hint
      "Remove the lines which are beginning with <<<<<<< or >>>>>>> or =======."
    end

    def self.check?(sourcefile)
      sourcefile.attributes['text']==true
    end

    def check
      leftovers=sourcefile.content.grep(LEFTOVER_PATTERN)
      unless leftovers.empty?
        errors.add(nil, "#{leftovers.size} line(s) of conflict leftovers")
      end
    end
  end
end

Codeqa::Runner.register_checker(Codeqa::CheckConflict)
