module Codeqa
  module Checkers
    class CheckYard < Checker
      def self.check?(sourcefile)
        sourcefile.attributes['language'] == 'ruby' && !(sourcefile.filename =~ /^(test|spec)/)
      end

      def name
        "yard"
      end

      def hint
        "Yard gives us some warnings on the file you can run <yardoc filename> to check yourself."
      end

      def check
        with_existing_file do |filename|
          IO.popen("/usr/bin/env yardoc '#{filename}' --no-stats --no-save --no-output") do |io|

            message = io.read
            #      syntax_warnings=message.grep(/\A\[warn\]: [^\Z]*syntax[^\Z]*\Z/i)
            warnings = message.match(/\A\[warn\]: /)
            errors.add(nil, message) if warnings
          end
        end
      end
    end
  end
end
