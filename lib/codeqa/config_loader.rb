require 'yaml'
require 'pathname'

module Codeqa
  class ConfigLoader
    DOTFILE = '.codeqa.yml'

    class << self
      def build_config
        if project_root == CODEQA_HOME
          default_configuration
        else
          tmp = deep_merge(default_configuration, home_configuration)
          deep_merge(tmp, project_configuration)
        end
      end

      def load_file(path)
        path = Pathname.new(path).realpath
        hash = YAML.load_file(path) || {}
        # puts "configuration from #{path}"

        make_excludes_absolute(hash)
      end

      def make_excludes_absolute(hash)
        if hash['Exclude']
          hash['Exclude'].map! do |exclude_elem|
            if exclude_elem.is_a?(String) && !exclude_elem.start_with?('/')
              File.join(project_root, exclude_elem)
            else
              exclude_elem
            end
          end
        end
        hash
      end

      # Return a recursive merge of two hashes. That is, a normal hash merge,
      # with the addition that any value that is a hash, and occurs in both
      # arguments, will also be merged. And so on.
      def deep_merge(base_hash, derived_hash)
        result = base_hash.merge(derived_hash)
        keys_appearing_in_both = base_hash.keys & derived_hash.keys
        keys_appearing_in_both.each do |key|
          if base_hash[key].is_a?(Hash) && derived_hash[key]
            result[key] = deep_merge(base_hash[key], derived_hash[key])
          elsif base_hash[key].is_a?(Array) && derived_hash[key]
            result[key] = base_hash[key] | derived_hash[key]
          end
        end
        result
      end

      def default_configuration
        load_file(File.join(CODEQA_HOME, 'config', 'default.yml'))
      end

      def home_configuration
        home_dir_config = File.join(home_dir, DOTFILE)
        if File.exist? home_dir_config
          load_file(home_dir_config)
        else
          {}
        end
      end

      def project_configuration
        project_root_config = File.join(project_root, DOTFILE)
        if File.exist? project_root_config
          load_file(project_root_config)
        else
          {}
        end
      end

      def home_dir
        @home_dir ||= if Dir.respond_to?(:home)
                        Dir.home
                      else
                        File.expand_path("~")
                      end
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
    end
  end
end
