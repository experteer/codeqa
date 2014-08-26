require 'codeqa/utils/erb_sanitizer'
require 'open3'
module Codeqa
  module Checkers
    class CheckErbHtml < Checker
      def self.check?(sourcefile)
        sourcefile.html?
      end

      def name
        'erb html'
      end

      def hint
        'The html I see after removing the erb stuff is not valid (find the unclosed tags and attributes).'
      end

      def check
        result = nil
        with_existing_file(html) do |filename|
          Open3.popen3("tidy -q -e -xml '#{filename}'") do |_in_stream, _out_stream, err_stream|
            message = err_stream.read
            result = message if message =~ /(Error:|missing trailing quote|end of file while parsing attributes)/m
          end # IO.popen
        end # Tempfile

        return unless result
        errors.add(:source, html)
        errors.add(nil, result)
      end

      def html
        @html ||= begin
                    html = ErbSanitizer.new(sourcefile.content).result
                    html = html.force_encoding('UTF-8') if html.respond_to?(:force_encoding)
                    html.gsub(%r{<script[ >].*?</script>|<style[ >].*?</style>}m,
                              '<!--removed script/style tag-->')
                  end
      end
    end
  end
end
