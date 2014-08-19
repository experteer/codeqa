require 'spec_helper'

describe Codeqa do
  context 'register_checkers' do
    it 'should first reset the checkers' do
      expect(Codeqa::Runner).to receive(:reset_checkers)
      Codeqa.register_checkers
    end
    it 'should constantize the checkers in config and add them to the registered_checkers' do
      Codeqa.configuration.enabled_checker = ['CheckErb']
      Codeqa.register_checkers
      expect(Codeqa::Runner.registered_checkers).to include(Codeqa::Checkers::CheckErb)
      load_test_config
    end
  end
  context 'check' do
    it 'should be true if the file is OK' do
      file = './spec/fixtures/ruby.rb'
      expect(Codeqa.check(file, :silent => true)).to be true
    end
    it 'should be false if the file is broken' do
      file = './spec/fixtures/ruby_error.rb'
      expect(Codeqa.check(file, :silent => true)).to be false
    end
  end

  context 'install' do
    let(:project_dir){ Codeqa.root.join('spec/fixtures/isolation/home/project') }
    before(:each) do
      FileUtils.mkdir_p(project_dir.join('.git', 'hooks'))
    end
    after(:each) do
      FileUtils.rm_rf(project_dir.join('.git'))
    end

    it 'should be true if folder looks like a git root' do
      expect(Codeqa.install(project_dir.to_s)).to be true
    end

    it 'should be false if folder does not look like a git root' do
      expect(Codeqa.install(Codeqa.root.join('spec', 'fixtures'))).to be false
    end

    it 'should copy pre-commit hook into project git folder' do
      template_location = Codeqa.root.join('lib', 'templates', 'pre-commit')
      hook_location = project_dir.join('.git', 'hooks', 'pre-commit')
      expect(FileUtils).to receive(:cp).with(template_location, hook_location)
      allow(FileUtils).to receive(:chmod)
      Codeqa.install project_dir.to_s
    end
  end
end
