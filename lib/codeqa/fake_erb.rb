require 'erb'
module Codeqa
  # copied from ERB
  # throws away all the erb stuff so only html remains
  # rubocop:disable MethodLength, LineLength, CyclomaticComplexity, BlockNesting
  class FakeERB < ERB
    def initialize(str, safe_level=nil, trim_mode=nil, eoutvar='_erbout', compiler_class=FakeERB::Compiler)
      @safe_level = safe_level
      compiler = compiler_class.new(trim_mode)
      set_eoutvar(compiler, eoutvar)
      @src = compiler.compile(str)
      @filename = nil
    end

    class Compiler < ERB::Compiler # :nodoc:
      def compile(s)
        out = Buffer.new(self)

        content = ''
        scanner = make_scanner(s)
        scanner.scan do |token|
          next if token.nil?
          next if token == ''
          if scanner.stag.nil?
            case token
            when PercentLine
              out.push("#{@put_cmd} #{content_dump(content)}") if content.size > 0
              content = ''
              out.push(token.to_s)
              out.cr
            when :cr
              out.cr
            when '<%', '<%=', '<%#'
              scanner.stag = token
              out.push("#{@put_cmd} #{content_dump(content)}") if content.size > 0
              content = ''
            when "\n"
              content << "\n"
              out.push("#{@put_cmd} #{content_dump(content)}")
              content = ''
            when '<%%'
              content << '<%'
            else
              content << token
            end
          else
            case token
            when '%>'
              case scanner.stag
              when '<%'
                if content[-1] == "\n"
                  content.chop!
                  # out.push(content)
                  out.cr
                else
                  # out.push(content)
                end
              when '<%='
                # out.push("#{@insert_cmd}((#{content}).to_s)")
              when '<%#'
                # out.push("# #{content_dump(content)}")
              end
              scanner.stag = nil
              content = ''
            when '%%>'
              content << '%>'
            else
              content << token
            end
          end
        end
        # puts "pushed2 #{content}"
        out.push("#{@put_cmd} #{content_dump(content)}") if content.size > 0
        out.close
        out.script
      end
    end
  end
  # rubocop:enable MethodLength, LineLength, CyclomaticComplexity, BlockNesting
end
