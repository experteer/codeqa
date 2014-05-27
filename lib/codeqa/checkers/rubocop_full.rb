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
        "rubocop"
      end

      def hint
        "Rubocop does not like your syntax, please fix your code."
      end

      def check
        if self.class.rubocop?
          with_existing_file do |filename|
            args = config_args << filename
            success, captured = capture{ ::Rubocop::CLI.new.run(default_args + args) == 0 }
            errors.add(nil, captured) unless success
          end
        end
      end

    private

      def config_args
        %w(--auto-correct --fail-level warning)
      end

      def default_args
        %w(--display-cop-names --format emacs)
      end

      def self.rubocop?
        @loaded ||= begin
                      require 'rubocop'
                      true
                    end
      end
    end
  end
end
