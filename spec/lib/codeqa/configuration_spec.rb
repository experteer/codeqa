require 'spec_helper'

describe Codeqa::Configuration do
  let(:subject){ Codeqa.configuration }

  it 'should be exposed in the Codeqa module' do
    expect(Codeqa).to respond_to(:configuration)
  end

  %w(excludes enabled_checker erb_engine rubocop_formatter_cops).each do |c|
    it "should provide :#{c}" do
      expect(Codeqa.configuration).to respond_to(c.to_sym)
    end
  end

  it 'should have the excludes set' do
    expect(Codeqa.configuration.excludes).to be_a(Set)
    expect(Codeqa.configuration.excludes).to eq(Set.new(['vendor/**/*']))
  end
  it 'should have the enabled checkers set' do
    expect(Codeqa.configuration.enabled_checker).to be_a(Set)
    exp_set = Set.new(%w(CheckStrangeChars
                         CheckUtf8Encoding
                         CheckConflict
                         CheckPry
                         RubocopLint))
    expect(Codeqa.configuration.enabled_checker).to eq(exp_set)
  end

  context 'exclude' do
    before(:each) do
      @org_dir = Dir.pwd
      project_root = Codeqa.root.join 'spec/fixtures/isolation/home/project'
      allow(Codeqa.configuration).to receive(:project_root).and_return(Pathname.new(project_root))
      Dir.chdir(project_root)
      Codeqa.configure{ |c| c.excludes = ['ignored/*', /tmp/, 'dont_check.rb', 'some/path/to/file.html'] }
    end
    after(:each) do
      Dir.chdir(@org_dir)
      load_test_config
    end
    it 'should be true for filenames within a foo folder' do
      expect(Codeqa.configuration.excluded?('ignored/some_file.txt')).to be true
    end
    it 'should be false for files unrelated to the excludes' do
      expect(Codeqa.configuration.excluded?('file.rb')).to be false
    end
    it 'should work with regex matches' do
      expect(Codeqa.configuration.excluded?('some/tmp/path')).to be true
    end
    it 'should match on the basename' do
      expect(Codeqa.configuration.excluded?('some/path/dont_check.rb')).to be true
    end
    it 'should match if the pattern is equal to the path' do
      expect(Codeqa.configuration.excluded?('some/path/to/file.html')).to be true
    end
  end
end
