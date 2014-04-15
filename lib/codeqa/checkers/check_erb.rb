begin
  require 'action_view'
rescue LoadError
  require 'erb'
end
module Codeqa
  module Checkers
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
          if defined?(ActionView)
            ActionView::Template::Handlers::Erubis.new(erb).result
          else
            ERB.new(sourcefile.content.gsub('<%=','<%'), nil, '-').result
            # ERB.new(sourcefile.content, nil, '-').result
          end
        rescue SyntaxError
          msg= $!.message
          msg << "\n"
          msg += $!.backtrace.join("\n")
          errors.add(nil, msg)
          return
        rescue Exception
          # valid syntax - just to proper setup for the template/rendering is missing
        end
      end
    end
  end
end

