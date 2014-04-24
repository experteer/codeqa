require 'codeqa/checkers/rubocop_full'

module Codeqa
  module Checkers
    class RubocopLint < Rubocop
      def name
        "rubocop lint"
      end

      def hint
        "Rubocop does not like your syntax, please fix your code."
      end

      def config_args
        %w(--lint --format emacs --fail-level error)
      end
    end
  end
end
