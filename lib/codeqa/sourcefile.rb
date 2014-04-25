module Codeqa
  class Sourcefile
    BINARY_PATTERN = /\.(swf|jpg|png|gif|pdf|xls|zip|eot|woff|ttf|mo|so)$/
    ERB_PATTERN = /\.(erb|rhtml|text\.html|text\.plain)$/
    HTML_PATTERN = /\.(rhtml|html|text\.html)/
    RUBY_PATTERN = /\.rb$/
    SPEC_PATTERN = /_spec\.rb$/

    def initialize(filename, content=nil)
      @filename = filename
      @content = content
      # ensure_file
    end

    attr_reader :filename

    def content
      @content ||= File.read(filename)
    end

    def exist?
      File.exist?(filename)
    end

    def text?
      !binary?
    end

    def binary?
      @binary ||= !!(filename =~ BINARY_PATTERN)
    end

    def ruby?
      @ruby ||= !!(filename =~ RUBY_PATTERN)
    end

    def erb?
      @erb ||= !!(filename =~ ERB_PATTERN)
    end

    def html?
      @html ||= !!(filename =~ HTML_PATTERN)
    end

    def spec?
      @spec ||= !!(filename =~ SPEC_PATTERN)
    end
  end
end
