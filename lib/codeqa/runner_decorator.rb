require 'colorize'
module Codeqa
  class RunnerDecorator
    def initialize(runner, options = {})
      @options = { colors: true }.merge(options)
      @runner = runner
      @msg = ''
    end

    def sourcefile_to_s
      head("Codeqa on :'#{@runner.sourcefile.filename}'\n")
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

    # rubocop:disable Metrics/MethodLength
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
              msg << position((i + 1).to_s.rjust(3)) << '|' << l
            end
          when Integer
            msg << info('Line: ') << position(type.to_s.rjust(3)) << '|' << info(content)
          when Array
            msg << info('Pos: ') << position(type.join(':').rjust(7)) << '|' << info(content)
          when nil
            msg << info(content)
          end
          msg << "\n"
        end
      end
      msg
    end
    # rubocop:enable Metrics/MethodLength

    # http://stackoverflow.com/questions/1489183/colorized-ruby-output
    def info(txt)
      txt
    end

    def head(txt)
      colorize(txt, :cyan)
    end

    def error(txt)
      colorize(txt, :red)
    end

    def warn(txt)
      colorize(txt, :light_red)
    end

    def position(txt)
      colorize(txt, :yellow)
    end

    def success(txt)
      colorize(txt, :green)
    end

    def colorize(txt, color_name)
      if @options[:colors]
        txt.colorize(color_name)
      else
        txt
      end
    end
  end
end
