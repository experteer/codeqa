require 'fileutils'

module Codeqa
  class Installer
    def self.call(app_root)
      new(app_root).call
    end

    def initialize(app_root)
      @app_root = Pathname.new(File.expand_path(app_root))
    end

    def call
      generate_dot_codeqa
      install_codeqa_git_hook
    end

  private

    def dot_path(*args)
      app_path('.codeqa').join(*args)
    end

    def app_path(*args)
      @app_root.join(*args)
    end

    def template_path(*args)
      Codeqa.root.join('lib', 'templates').join(*args)
    end

    # return true if installation succeeded
    # return false if either no git repo or hook already present
    def install_codeqa_git_hook
      git_root = app_path.join('.git')
      pre_commit_path = git_root.join 'hooks', 'pre-commit'

      return false unless File.exist?(git_root)
      return false if File.exist?(pre_commit_path)
      # an alternative would be to backup the old hook
      # FileUtils.mv(pre_commit_path,
      #             git_root.join('hooks', 'pre-commit.bkp'),
      #             :force => true)
      pre_commit_path.make_symlink('../../.codeqa/git_hook.rb') # relative path!
      true
    end

    def generate_dot_codeqa
      dot_path.mkdir unless dot_path.exist?
      dot_path('hooks').mkdir unless dot_path('hooks').exist?
      FileUtils.cp(template_path('base_hook.rb'), dot_path('hooks', 'base.rb')) unless dot_path('hooks', 'base.rb').exist?
      FileUtils.cp(template_path('git_hook.rb'), dot_path('git_hook.rb')) unless  dot_path('git_hook.rb').exist?
      dot_path('git_hook.rb').chmod(0775)
    end
  end
end
