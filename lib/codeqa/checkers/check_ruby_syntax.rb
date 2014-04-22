require 'erb'
module Codeqa
  module Checkers
    class CheckRubySyntax < Checker
      def self.check?(sourcefile)
        sourcefile.attributes['language'] == 'ruby'
      end

      def name
        "ruby syntax"
      end

      def hint
        "Ruby can not parse the file, please check it for syntax errors."
      end

      def check
        with_existing_file do |filename|

          command = "/usr/bin/env ruby -c '#{filename}' 1>/dev/null 2>/dev/null"
          unless system(command)
            errors.add(nil, "Ruby syntax error")
          end
        end
      end
    end
  end
end
