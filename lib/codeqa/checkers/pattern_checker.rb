module Codeqa
  module Checkers
    class PatternChecker < Checker
      def check
        sourcefile.content.lines.each.with_index do |line, line_number|
          pos = (line =~ self.class::PATTERN)
          errors.add("#{line_number + 1},#{pos + 1}", error_msg(line, line_number + 1, pos)) if pos
        end
      end

      def self.available?
        defined?(self.class::PATTERN) == 'constant'
      end

    private

      def error_msg(*_args)
        raise "not implemented"
      end
      # PATTERN = //
    end
  end
end
