module Codeqa
  module Checkers
    class PatternChecker < Checker
      def check
        match = sourcefile.content.match(self.class::PATTERN)
        errors.add(nil, error_msg(match)) if match
      end

      def self.available?
        defined?(self.class::PATTERN) == 'constant'
      end

    private

      def error_msg(match)
        raise "not implemented"
      end
      # PATTERN = //
    end
  end
end
