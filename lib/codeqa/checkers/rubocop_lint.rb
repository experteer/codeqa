require 'codeqa/checkers/rubocop_full'

module Codeqa
  module Checkers
    class RubocopLint < Rubocop
      def name
        'rubocop lint'
      end

      def hint
        'Rubocop found syntax errors, please fix your code.'
      end

    private

      def config_args
        %w(--lint --fail-level error)
      end
    end
  end
end
