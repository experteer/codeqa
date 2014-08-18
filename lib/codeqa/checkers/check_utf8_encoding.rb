module Codeqa
  module Checkers
    class CheckUtf8Encoding < Checker
      def self.check?(sourcefile)
        sourcefile.text?
      end

      def name
        'utf8 encoding'
      end

      def hint
        'The file contains non utf8 characters. Find and remove them.'
      end

      def check
        return if sourcefile.content.force_encoding('UTF-8').valid_encoding?
        errors.add(nil, 'encoding error, not utf8')
      end
    end
  end
end
