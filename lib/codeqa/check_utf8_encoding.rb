require 'iconv'
module Codeqa
  class CheckUtf8Encoding < Checker
    def self.check?(sourcefile)
      sourcefile.attributes['text']==true
    end

    def name
      "utf8 encoding"
    end

    def hint
      "The file contains non utf8 characters. Find and remove them."
    end

    def check
      begin
        out = Iconv.iconv('ucs-2', 'utf-8', sourcefile.content)
      rescue Errno::EINVAL, Errno::EISDIR
        # filename is a softlink directory
      rescue Errno::ENOENT
        #no file? we're not interested
      rescue => err
        errors.add(nil, "encoding error, not utf8")
      end
    end
  end
end

Codeqa::Runner.register_checker(Codeqa::CheckUtf8Encoding)
