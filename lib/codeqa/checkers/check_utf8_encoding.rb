require 'iconv' unless Codeqa.new_ruby_version

module Codeqa
  module Checkers
    class CheckUtf8Encoding < Checker
      def self.check?(sourcefile)
        sourcefile.attributes['text'] == true
      end

      def name
        "utf8 encoding"
      end

      def hint
        "The file contains non utf8 characters. Find and remove them."
      end

      if Codeqa.new_ruby_version
        def check
          unless sourcefile.content.force_encoding("UTF-8").valid_encoding?
            errors.add(nil, "encoding error, not utf8")
          end
        end
      else
        # rubocop:disable RescueException,HandleExceptions
        def check
          Iconv.iconv('ucs-2', 'utf-8', sourcefile.content)
        rescue Errno::EINVAL, Errno::EISDIR
          # filename is a softlink directory
        rescue Errno::ENOENT
          # no file? we're not interested
        rescue# => err
          errors.add(nil, "encoding error, not utf8")
        end
        # rubocop:enable RescueException,HandleExceptions
      end
    end
  end
end
