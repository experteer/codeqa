require 'spec_helper'

describe Codeqa::ConfigLoader do

  context "file loading" do
    before(:each) do
      @org_dir = Dir.pwd
      Dir.chdir("./spec/fixtures/isolation/home/project/dir")
      described_class.stub(:home_dir).and_return(File.expand_path("../../"))
      described_class.stub(:project_root).and_return(File.expand_path("../"))
    end
    after(:each) do
      Dir.chdir(@org_dir)
    end

    it "should find the project folder" do
      expect(described_class.git_root_till_home.to_s).to eql(File.expand_path("../"))
    end
    it "should find the home dir config" do
      expect(described_class.home_configuration).to eql("CheckErbHtml" => { "Enabled" => false })
    end
    it "should find the project config" do
      project_config = {
        "Exclude"  => ["/home/aeger/code/codeqa/spec/fixtures/isolation/home/project/ignored/**/*"],
        "CheckErb" => { "Enabled" => false }
      }
      expect(described_class.project_configuration).to eql(project_config)
    end

    it "should load and merge all config files correctly" do
      config = {
        "Exclude"           => [
          "/home/aeger/code/codeqa/spec/fixtures/isolation/home/project/vendor/**/*",
          "/home/aeger/code/codeqa/spec/fixtures/isolation/home/project/ignored/**/*"],
        "CheckErb"          => { "Enabled" => false },
        "CheckErbHtml"      => { "Enabled" => false },
        "CheckLinkto"       => { "Enabled" => true },
        "CheckRubySyntax"   => { "Enabled" => true },
        "RubocopLint"       => { "Enabled" => false },
        "CheckStrangeChars" => { "Enabled" => true },
        "CheckUtf8Encoding" => { "Enabled" => true },
        "CheckYard"         => { "Enabled" => false },
        "CheckConflict"     => { "Enabled" => true },
        "CheckPry"          => { "Enabled" => true },
        "CheckRspecFocus"   => { "Enabled" => true }
      }
      expect(described_class.build_config).to eql(config)
    end
  end
  context "#deep_merge" do
    it "can merge simple hashes" do
      h1 = { :some => 'value' }
      h2 = { :other => 'key' }
      expect(described_class.deep_merge(h1, h2)).to eql(:some => 'value', :other => 'key')
    end
    it "can merge hashes with same key" do
      h1 = { :some => 'value' }
      h2 = { :some => 'key' }
      expect(described_class.deep_merge(h1, h2)).to eql(:some => 'key')
    end
    it "can merge arrays as keys" do
      h1 = { :some => [1, 2, 3] }
      h2 = { :some => [2, 3, 4] }
      expect(described_class.deep_merge(h1, h2)).to eql(:some => [1, 2, 3, 4])
    end
    it "can merge hashes as keys" do
      h1 = { :some => { :deep => 'keys' } }
      h2 = { :some => { :deep => 'values', :and => 'more' } }
      expect(described_class.deep_merge(h1, h2)).to eql(:some => { :deep => 'values', :and => 'more' })
    end
  end
end
