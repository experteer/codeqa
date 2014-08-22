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
        'erb syntax'
      end

      def hint
        'There is a syntax error in the ruby code of the erb parsed file.'
      end

      # rubocop:disable RescueException,HandleExceptions
      def check
        if defined?(ActionView)
          ActionView::Template::Handlers::Erubis.new(erb).result
        else
          ERB.new(sourcefile.content.gsub('<%=', '<%'), nil, '-').result
        end
      rescue SyntaxError => e
        errors.add(nil, <<-EOF)
        #{e.message}
        #{e.backtrace.join("\n")}
        EOF
      rescue Exception
        true # valid syntax - just the proper setup for the template/rendering is missing
      end
      # rubocop:enable RescueException,HandleExceptions

      def self.engine?
        @@engine ||= if %w(actionview action_view).include? Codeqa.configuration.erb_engine.downcase
                       require 'action_view'
                       true
                     else
                       require 'erb'
                       true
                     end
      end
    end
  end
end
