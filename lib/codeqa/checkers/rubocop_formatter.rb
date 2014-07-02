require 'codeqa/checkers/rubocop_full'

module Codeqa
  module Checkers
    class RubocopFormatter < Rubocop
      def name
        "rubocop formatter"
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
        %w(--auto-correct ) + active_cops
      end

      def active_cops
        %w( EmptyLinesAroundBody
            EmptyLines
            TrailingWhitespace
            SpaceBeforeBlockBraces
            SpaceInsideBlockBraces
            SpaceAroundEqualsInParameterDefault
            SpaceAfterComma
            SingleSpaceBeforeFirstArg
            SpaceInsideHashLiteralBraces
            SpaceAroundOperators
            SpaceInsideParens
            LeadingCommentSpace
            EmptyLineBetweenDefs
            IndentationConsistency
            IndentationWidth
            MethodDefParentheses
            DefWithParentheses
            HashSyntax
            AlignHash
            AlignArray
            AlignParameters
            BracesAroundHashParameters
        ).map{ |e| "--only #{e}" }
        # SignalException
        # DeprecatedClassMethods
        # RedundantBegin
        # RedundantSelf
        # RedundantReturn
        # CollectionMethods
      end
    end
  end
end
