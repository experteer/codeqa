require 'set'

module Codeqa
  class Runner
    class << self
      def registered_checkers
        @@registered_checkers
      end

      def reset_checkers
        @@registered_checkers = Set.new
      end

      def register_checker(checker_class)
        @@registered_checkers << checker_class
      end
    end
    @@registered_checkers = reset_checkers

    # run the checks on source
    def self.run(sourcefile)
      runner = new(sourcefile)
      runner.run
      runner
    end

    def initialize(sourcefile)
      @sourcefile = sourcefile
      @results = []
    end
    attr_reader :sourcefile

    def run
      return @results unless @results.empty?
      @results = @@registered_checkers.map do |checker_klass|
        next unless checker_klass.check?(sourcefile)
        checker = checker_klass.new(sourcefile)

        checker.before_check if checker.respond_to?(:before_check)
        checker.check
        checker.after_check if checker.respond_to?(:after_check)
        checker
      end.compact
    end

    # the results (checker instances of the run)
    attr_reader :results

    def failures
      @failures ||= @results.reject(&:success?)
    end

    def success?
      failures.empty?
    end

    def display_result(options={})
      RunnerDecorator.new(self, options)
    end
  end
end
