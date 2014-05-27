module Codeqa
  module Checkers
    class CheckErb < Checker
      def self.check?(sourcefile)
        sourcefile.erb?
      end

      def self.available?
        engine?
      end

      def name
        "erb syntax"
      end

      def hint
        "There is a syntax error in the ruby code of the erb parsed file."
      end

      # rubocop:disable RescueException,HandleExceptions
      def check
        if defined?(ActionView)
          ActionView::Template::Handlers::Erubis.new(erb).result
        else
          ERB.new(sourcefile.content.gsub('<%=', '<%'), nil, '-').result
        end
      rescue SyntaxError
        errors.add(nil, <<-EOF)
        #{$!.message}
        #{$!.backtrace.join("\n")}
        EOF
      rescue Exception
        true # valid syntax - just the proper setup for the template/rendering is missing
      end
      # rubocop:enable RescueException,HandleExceptions

    private

      def self.engine?
        @engine ||= if settings.fetch('Engine', 'erb').downcase == 'actionview'
                      require 'action_view'
                    else
                      require 'erb'
                    end
      end
    end
  end
end
