require 'erb'
module Codeqa
  class CheckRubySyntax < Checker
    def self.check?(sourcefile)
      sourcefile.attributes['language']=='ruby'
    end

    def name
      "ruby syntax"
    end

    def hint
      "Ruby can't parse the file, please check it for syntax errors."
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