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
        doc = Nokogiri::XML html
        binding.pry
        doc.errors.each do |error|
          errors.add(nil, error)
        end
      end

    private

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
