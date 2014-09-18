require 'set'
module Codeqa
  class Configuration
    # the default config file will setup all variables to some sane defaults
    attr_accessor :erb_engine
    attr_reader :excludes,
                :enabled_checker,
                :rubocop_formatter_cops

    def excludes=(val)
      @excludes = Set[*val]
    end

    def enabled_checker=(val)
      @enabled_checker = Set[*val]
    end

    def rubocop_formatter_cops=(val)
      @rubocop_formatter_cops = Set[*val]
    end

    def default_config_path
      Codeqa.root.join('config', 'default')
    end

    def home_config_path
      home_dir_config = File.join(home_dir, DOTFILE)
      return home_dir_config if File.exist? home_dir_config
      false
    end

    def project_config_path
      project_root_config = File.join(project_root, DOTFILE)
      return project_root_config if File.exist? project_root_config
      false
    end

    #
    # tests a given filepath if it should be excluded
    # @param file File.join compatable filepath
    #
    # @return [Boolean]
    def excluded?(file)
      file = File.join(Dir.pwd, file) unless file.start_with?('/')
      Codeqa.configuration.excludes.any? { |pattern| match_path?(pattern, file) }
    end

  private

    DOTFILE = '.codeqa.rb'

    def home_dir
      @home_dir ||= Dir.home
    end

    def project_root
      @project_root ||= git_root_till_home
    end

    # ascend from the current dir till I find a .git folder or reach home_dir
    def git_root_till_home
      Pathname.new(Dir.pwd).ascend do |dir_pathname|
        return dir_pathname if File.directory?("#{dir_pathname}/.git")
        return nil if dir_pathname.to_s == home_dir
      end
    end

    def match_path?(pattern, path)
      case pattern
      when String
        basename = File.basename(path)
        pattern = File.join(project_root, pattern) unless pattern.start_with?('/')
        path == pattern || basename == pattern || File.fnmatch(pattern, path)
      when Regexp
        path =~ pattern
      end
    end
  end

  class << self
    def configuration
      @configuration ||=  Configuration.new
    end

    def configure
      yield(configuration) if block_given?
      Codeqa.register_checkers
    end
  end
end

require Codeqa.configuration.default_config_path
require Codeqa.configuration.home_config_path if Codeqa.configuration.home_config_path
require Codeqa.configuration.project_config_path if Codeqa.configuration.project_config_path
