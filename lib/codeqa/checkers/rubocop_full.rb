require 'rubocop'

module Codeqa
  module Checkers
    class Rubocop < Checker
      def self.check?(sourcefile)
        sourcefile.attributes['language']=='ruby'
      end

      def name
        "rubocop"
      end

      def hint
        "Rubocop does not like your syntax, please fix your code."
      end

      def check
        with_existing_file do |filename|
          args = config_args << filename
          success, captured = capture { ::Rubocop::CLI.new.run(args) == 0 }
          errors.add(nil, captured) unless success
        end
      end
      def config_args
        ['--format', 'emacs', '--fail-level', 'warning']
      end
    end
  end
end