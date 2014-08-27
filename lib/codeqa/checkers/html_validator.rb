require 'codeqa/utils/erb_sanitizer'
require 'nokogiri'

module Codeqa
  module Checkers
    class HtmlValidator < Checker
      def self.check?(sourcefile)
        sourcefile.html?
      end

      def self.available?
        nokogiri?
      end

      def name
        'html'
      end

      def hint
        'Nokogiri found XHTML errors, please fix them.'
      end

      REMOVED_NOKOGIRI_ERRORS = Regexp.union(
        /Opening and ending tag mismatch: (special line 1|\w+ line 1 and special)/,
        /Premature end of data in tag special/,
        /Extra content at the end of the document/,
        /xmlParseEntityRef: no name/,
        /Entity 'nbsp' not defined/
      )
      def check
        return unless self.class.nokogiri?
        doc = Nokogiri::XML "<special>#{stripped_html}</special>"

        doc.errors.delete_if{ |e| e.message =~ REMOVED_NOKOGIRI_ERRORS }
        errors.add(:source, sourcefile.content) unless doc.errors.empty?
        # errors.add(:source, stripped_html) unless doc.errors.empty?
        doc.errors.each do |error|
          errors.add(error.line, error.message) unless error.warning?
        end
      end

      def stripped_html
        @html ||= ErbSanitizer.new(sourcefile.content).result
      end

      def self.nokogiri?
        @loaded ||= begin
                      require 'nokogiri'
                      true
                    end
      end
    end
  end
end
