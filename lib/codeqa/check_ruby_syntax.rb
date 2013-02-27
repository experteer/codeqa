require 'erb'
module Codeqa
  class CheckRubySyntax < Checker
    def self.check?(sourcefile)
      sourcefile.attributes['language']=='ruby'
    end

    def check
      with_existing_file do |filename|
        unless system("ruby -c '#{filename}' 1>/dev/null 2>/dev/null")
          errors.add(nil, "Ruby syntax error")
        end
      end
    end
  end
end

Codeqa::Runner.register_checker(Codeqa::CheckRubySyntax)