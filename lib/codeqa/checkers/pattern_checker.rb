module Codeqa
  module Checkers
    class PatternChecker < Checker
      def check
        sourcefile.content.lines.each.with_index do |line, line_number|
          pos = (line =~ pattern)
          errors.add([line_number + 1, pos + 1], error_msg(line, line_number + 1, pos)) if pos
        end
      end

      def self.available?
        respond_to?(:pattern)
      end

    private

      def pattern
        self.class.pattern
      end

      def error_msg(*_args)
        raise 'not implemented'
      end
    end
  end
end
