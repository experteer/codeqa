module Codeqa
  class CheckYard < Checker
    def self.check?(sourcefile)
      sourcefile.attributes['language']=='ruby'
    end

    def name
      "yard"
    end

    def hint
      "Yard gives us some warnings on the file you can run 'yardoc filename' to check yourself."
    end

    def check
      IO.popen("yardoc '#{source.filename}' --no-save --no-output") do |io|
        message=io.read;
        #      syntax_warnings=message.grep(/\A\[warn\]: [^\Z]*syntax[^\Z]*\Z/i)
        warnings=message.grep(/\A\[warn\]: /)
        unless warnings.empty?
          errors.add(nil, "#{warnings.size} lines of yard warnings")
        else
          #puts "yard check ...........ok"
        end
      end
    end
  end
end

Codeqa::Runner.register_checker(Codeqa::CheckYard)