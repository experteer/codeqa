module Codeqa
  class RunnerDecorator
    def initialize(runner, options={})
      @options = { :colors => true }.merge(options)
      @runner = runner
      @msg = ''
    end

    def sourcefile_to_s
      info("Codeqa on :'#{@runner.sourcefile.filename}'\n")
    end

    def success_to_s
      if @runner.success?
        success("Passed tests: #{@runner.results.map(&:name).join(', ')}\n")
      else
        error("Failed tests: #{@runner.failures.map(&:name).join(', ')}\n")
      end
    end

    def details_to_s
      error_details
    end

    def to_s
      @msg << sourcefile_to_s
      @msg << success_to_s
      @msg << details_to_s unless @runner.success?

      @msg
    end

  private

    # TODO: move this error formating into check error class
    def error_details
      msg = ''
      @runner.failures.each do |checker|
        # msg << error("------- #{checker.name} -------") << "\n"
        # msg << error("#{checker.hint}") << "\n"
        checker.errors.details.each do |type, content|
          case type
          when :source
            content.each_line.with_index do |l, i|
              msg << yellow((i + 1).to_s.rjust(3)) << '|' << l
            end
          when Integer
            msg << info('Line: ') << yellow(type) << '|' << info(content)
          when Array
            msg << info('Pos: ') << yellow(type.join(',')) << '|' << info(content)
          when nil
            msg << info(content)
          end
          msg << "\n"
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

    def colorize(color_code, txt)
      if @options[:colors]
        "\e[#{color_code}m#{txt}\e[0m"
      else
        txt
      end
    end

    def red(txt)
      colorize(31, txt)
    end

    def green(txt)
      colorize(32, txt)
    end

    def yellow(txt)
      colorize(33, txt)
    end

    # def pink(txt)
    #   colorize(35, txt)
    # end
  end
end
