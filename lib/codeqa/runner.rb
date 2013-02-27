module Codeqa
  class Runner

    @@registered_checkers=[] #I want this to be inheritable

    def self.register_checker(checker_class)
      @@registered_checkers << checker_class
    end

    #run the checks on source
    def self.run(sourcefile)
      runner=self.new(sourcefile)
      runner.run
      runner
    end


    def initialize(sourcefile)
      @sourcefile=sourcefile
      @results=[]
    end
    attr_reader :sourcefile

    def matching_checkers
      @matching_checkers ||= @@registered_checkers.reject do |checker_class| !checker_class.check?(sourcefile) end
    end

    def run
      return @results unless @results.empty?
      @results = matching_checkers.map do |checker_class|
        checker=checker_class.new(sourcefile)

        checker.check
        checker
      end

    end

    #the results (checker instances of the run)
    attr_reader :results

    def failures
      #return @failures if @failures
      @failures ||= @results.reject do |checker| checker.success? end
    end

    def success?
      failures.empty?
    end

    def display_result(options={})
      RunnerDecorator.new(self,options)
    end
  end
end
