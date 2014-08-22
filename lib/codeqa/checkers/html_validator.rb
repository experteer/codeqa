require 'codeqa/fake_erb'

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
        /xmlParseEntityRef: no name/
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

      ERB_OPEN = %r{<%(-|=)?}
      ERB_CLOSE = %r{-?%>}
      ERB_IN_ATTR = %r{(?<before>"[^<"]*)<%(?:[^>]*)%>(?<after>[^"]*")}
      ERB_IN_TAG = %r{(?<before><[^<]*)<%(?:[^>]*)%>(?<after>[^>]*>)}
      SCRIPT_TAG = %r{<script[ >].*?</script>|<style[ >].*?</style>}m
      HASH_ROCKET = /=>/
      NBSP = '&nbsp;'
      def stripped_html
        sourcefile.content.
                  force_encoding('UTF-8').
                  gsub(/"<%(?:[^"]+)%>"/, '""').
                  gsub(ERB_IN_ATTR, '\k<before>\k<after>').
                  gsub(ERB_IN_ATTR, '\k<before>\k<after>').
                  gsub(ERB_IN_ATTR, '\k<before>\k<after>').
                  gsub(ERB_IN_TAG, '\k<before>\k<after>').
                  # gsub(ERB_IN_ATTR_SINGLE, '\k<before>\k<after>').
                  # gsub(ERB_IN_ATTR_SINGLE, '\k<before>\k<after>').
                  gsub(%r{<!--\[if lte IE \d+\]>|<!\[endif\]-->}, '').
                  gsub(ERB_OPEN, '<!--').
                  gsub(ERB_CLOSE, '-->').
                  gsub(HASH_ROCKET, '').
                  gsub(NBSP, '').
                  gsub(SCRIPT_TAG, '')
      end

      def html
        @html ||= begin
                    html = FakeERB.new(sourcefile.content.gsub('<%=', '<%')).result
                    html = html.force_encoding('UTF-8') if html.respond_to?(:force_encoding)
                    html.gsub(%r{<script[ >].*?</script>|<style[ >].*?</style>}m,
                              '<!--removed script/style tag-->')
                  end
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
