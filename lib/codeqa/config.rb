require 'singleton'
module Codeqa
  class Config
    include Singleton
    attr_reader :loaded

    def self.load
      instance.hash = ConfigLoader.build_config
      instance
    end

    def self.loaded?
      instance.loaded
    end

    def hash=(v)
      @hash = v
      @loaded = true
    end

    def excluded?(file)
      file = File.join(Dir.pwd, file) unless file.start_with?('/')
      patterns_to_exclude.any?{ |pattern| match_path?(pattern, file) }
    end

    def enabled?(checker_klass)
      !!@hash.fetch(checker_klass.to_s.split('::').last, {}).fetch('Enabled', false)
    end

  private

    def patterns_to_exclude
      @hash['Exclude']
    end

    def match_path?(pattern, path)
      case pattern
      when String
        basename = File.basename(path)
        path == pattern || basename == pattern || File.fnmatch(pattern, path)
      when Regexp
        path =~ pattern
      end
    end
  end
end
