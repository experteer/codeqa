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
    # before(:each) do
    #   @org_dir = Dir.pwd
    #   Dir.chdir('./spec/fixtures/isolation/home/project/dir')
    #   described_class.stub(:home_dir).and_return(File.expand_path('../../'))
    #   described_class.stub(:project_root).and_return(File.expand_path('../'))
    # end
    # after(:each) do
    #   Dir.chdir(@org_dir)
    # end

    let(:project_dir){ Codeqa.root.join('spec/fixtures/isolation/home/project') }
    after(:each) do
      File.delete(project_dir.join('.git/hooks/pre-commit'))
      File.delete(project_dir.join('.git/hooks/pre-commit.bkp'))
    end
    it 'should copy pre-commit hook into project git folder' do
      Codeqa.install project_dir.to_s
      expect(File.exist?(project_dir.join('.git/hooks/pre-commit'))).to be true
    end
  end
end
