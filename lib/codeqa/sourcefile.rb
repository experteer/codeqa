module Codeqa
  class Sourcefile
    BINARY_PATTERN = /\.(swf|jpg|png|gif|pdf|xls|zip|eot|woff|ttf|mo|so)$/
    ERB_PATTERN = /\.(erb|rhtml|text\.html|text\.plain)$/
    HTML_PATTERN = /\.(rhtml|html|text\.html)/
    RUBY_PATTERN = /\.rb$/

    def initialize(filename, content=nil)
      @filename = filename
      @content = content
      # ensure_file
    end

    attr_reader :filename

    def content
      @content ||= File.read(filename)
    end

    def attributes
      return @attributes if @attributes
      @attributes = {}
      if binary?
        @attributes['binary'] = true
        @attributes['text'] = false
      else
        @attributes['binary'] = false
        @attributes['text'] = true
      end
      @attributes['eruby'] = true if erb?
      @attributes['language'] = 'ruby' if ruby?
      @attributes['language'] = 'html' if html?
      @attributes
    end

    def exist?
      File.exist?(filename)
    end

  private

    def binary?
      filename =~ BINARY_PATTERN
    end

    def ruby?
      filename =~ RUBY_PATTERN
    end

    def erb?
      filename =~ ERB_PATTERN
    end

    def html?
      filename =~ HTML_PATTERN
    end
  end
end
