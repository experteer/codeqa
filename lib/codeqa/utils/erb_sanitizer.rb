require 'erb'
# Based on ERB source from ruby 2.1.2
# https://github.com/ruby/ruby/blob/v2_1_2/lib/erb.rb#L597
module Codeqa
  class ErbSanitizer < ERB
    def make_compiler(trim_mode)
      ErbSanitizer::Compiler.new(trim_mode)
    end

    class Compiler < ERB::Compiler
      # Compiles an ERB template into Ruby code.  Returns an array of the code
      # and encoding like ["code", Encoding].
      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
      def compile(s)
        enc = s.encoding
        raise ArgumentError, "#{enc} is not ASCII compatible" if enc.dummy?
        s = s.b # see String#b
        enc = detect_magic_comment(s) || enc
        out = Buffer.new(self, enc)

        content = ''
        scanner = make_scanner(s)
        scanner.scan do |token|
          next if token.nil?
          next if token == ''
          if scanner.stag.nil?
            case token
            when PercentLine
              add_put_cmd(out, content) if content.size > 0
              content = ''
              out.push(token.to_s)
              out.cr
            when :cr
              out.cr
            when '<%', '<%=', '<%#'
              scanner.stag = token
              add_put_cmd(out, content) if content.size > 0
              content = ''
            when "\n"
              content << "\n"
              add_put_cmd(out, content)
              content = ''
            when '<%%'
              content << '<%'
            else
              content << token
            end
          else
            case token
            when '%>'
              # in here we deal with the content of a erb tag
              content.scan("\n").count.times do
                add_put_cmd(out, "\n")
              end
              # case scanner.stag
              # when '<%'
              #   if content[-1] == ?\n
              #     content.chop!
              #     out.push(content)
              #     out.cr
              #   else
              #     out.push(content)
              #   end
              # when '<%='
              #   add_insert_cmd(out, content)
              # when '<%#'
              #   # out.push("# #{content_dump(content)}")
              # end
              scanner.stag = nil
              content = ''
            when '%%>'
              content << '%>'
            else
              content << token
            end
          end
        end
        add_put_cmd(out, content) if content.size > 0
        out.close
        [out.script, enc]
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    end
  end
end
