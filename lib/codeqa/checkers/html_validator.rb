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

      def check
        return unless self.class.nokogiri?
        doc = Nokogiri::XML stripped_html
        doc.errors.each do |error|
          errors.add(error.line, error.message) unless error.warning?
        end
      end

      ERB_OPEN = %r{<%}
      ERB_CLOSE = %r{%>}
      ERB_IN_ATTR = %r{(?<before>"[^<"]*)<%(?:.*)%>(?<after>[^"]*")}
      SCRIPT_TAG = %r{<script[ >].*?</script>|<style[ >].*?</style>}m
      def stripped_html
        sourcefile.content.
                  force_encoding('UTF-8').
                  gsub(SCRIPT_TAG, '<!--removed script/style tag-->').
                  gsub(ERB_IN_ATTR, '\k<before>\k<after>').
                  gsub(ERB_IN_ATTR, '\k<before>\k<after>').
                  gsub(ERB_OPEN, '<!--').
                  gsub(ERB_CLOSE, '-->')
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
