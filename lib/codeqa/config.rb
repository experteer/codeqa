require 'singleton'
module Codeqa
  class Config# < DelegateClass(Hash)
    include Singleton

    def self.load
      self.instance.set_config(ConfigLoader.get_config_hash)
      self.instance
    end
    def self.for(checker_klass)
      self.instance[checker_klass.to_s.split('::').last]
    end

    def set_config(hash)
      @hash = hash
    end
    def excluded?(file)
      file = File.join(Dir.pwd, file) unless file.start_with?('/')
      patterns_to_exclude.any? { |pattern| match_path?(pattern, file) }
    end
    def enabled?(checker_klass)
      !!@hash[checker_klass.to_s.split('::').last]['Enabled']
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