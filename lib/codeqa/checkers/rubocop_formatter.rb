require 'codeqa/checkers/rubocop_full'

module Codeqa
  module Checkers
    class RubocopFormatter < Rubocop
      def name
        'rubocop formatter'
      end

      def hint
        <<-EOF
Rubocop reformatted your code.
Check what it has done and add the changes to git's index
EOF
      end

      def after_check
        # add changes to the git index
        # `git add #{sourcefile.filename}`
      end

    private

      def config_args
        %w(--auto-correct --only ) << Codeqa.configuration.rubocop_formatter_cops.to_a.join(',')
      end
    end
  end
end
