require 'multi_json'

module Codeqa
  module Checkers
    class Rubocop < Checker
      def self.check?(sourcefile)
        sourcefile.ruby?
      end

      def self.available?
        rubocop?
      end

      def name
        'rubocop'
      end

      def hint
        'Rubocop does not like your syntax, please fix your code.'
      end

      def check
        return unless self.class.rubocop?
        with_existing_file do |filename|
          args = config_args << filename
          success, raw_json = capture do
            ::RuboCop::CLI.new.run(default_args + args) == 0
          end
          handle_rubocop_results(raw_json) unless success
        end
      end

    private

      def config_args
        %w(--auto-correct)
      end

      def default_args
        %w(--format json)
      end

      def handle_rubocop_results(raw)
        MultiJson.load(raw)['files'].
                 reject { |f| f['offenses'].empty? }.
                 each do |file|
                   file['offenses'].each do |offense|
                     position = [offense['location']['line'], offense['location']['column']]
                     errors.add(position, "#{offense['cop_name']}: #{offense['message']}")
                   end
                 end
      end
      def self.rubocop?
        @loaded ||= begin
                      require 'rubocop'
                      true
                    end
      end

      # Since using the json format we only care about stdout
      # stderr will be silenced
      # (internal rubocop errors/warning will be printed there)
      def capture
        $stdout, stdout = StringIO.new, $stdout
        $stderr, stderr = StringIO.new, $stderr
        result = yield
        # [result, $stdout.string + $stderr.string]
        [result, $stdout.string]
      ensure
        $stdout = stdout
        $stderr = stderr
      end
    end
  end
end
