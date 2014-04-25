module Codeqa
  module Checkers
    class PatternChecker < Checker
      def check
        sourcefile.content.lines.each.with_index(1) do |line, line_number|
          pos = (line =~ self.class::PATTERN)
          errors.add("#{line_number},#{pos + 1}", error_msg(line, line_number, pos)) if pos
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
