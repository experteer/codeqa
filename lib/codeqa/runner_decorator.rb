module Codeqa
  class RunnerDecorator
    def initialize(runner, options={})
      @runner=runner
      @options=options
      @msg=""
    end

    def to_s
      @msg << info("Codeqa on :'#{@runner.sourcefile.filename}'\n")
      if @runner.success?
        @msg << success("Passed tests: #{@runner.results.map(&:name).join(', ')}\n")
      else
        @msg << error("Failed tests: #{@runner.failures.map(&:name).join(', ')}\n")
        @msg << error_details
      end

      @msg
    end

    private
    def error_details
      msg=""
      @runner.failures.each do |checker|
        msg << error("------- #{checker.name} -------\n")
        msg << error("#{checker.hint}\n")
        checker.errors.details.each do |detail|
          msg << info("#{detail[1]}\n")
        end
      end
      msg
    end


    # http://stackoverflow.com/questions/1489183/colorized-ruby-output
    def info(txt)
      txt
    end

    def error(txt)
      red(txt)
    end

    def success(txt)
      green(txt)
    end


    def colorize(color_code,txt)
      "\e[#{color_code}m#{txt}\e[0m"
    end

    def red(txt)
      colorize(31,txt)
    end

    def green(txt)
      colorize(32,txt)
    end

    def yellow(txt)
      colorize(33,txt)
    end

    def pink(txt)
      colorize(35,txt)
    end

    def reset
      "\033[0m"
    end
  end
end