require 'erb'
module Codeqa
  class CheckErb < Checker
    def self.check?(sourcefile)
      sourcefile.attributes['eruby']==true
    end

    def name
      "erb syntax"
    end

    def hint
      "There is a syntax error in the ruby code of the erb parsed file."
    end

    def check
      begin
        ERB.new(sourcefile.content, nil, '-').result
      rescue SyntaxError
        msg= $!.message
        msg << "\n"
        msg += $!.backtrace.join("\n")
        errors.add(nil, msg)
        return
      rescue Exception

      end
    end
  end
end

Codeqa::Runner.register_checker(Codeqa::CheckErb)