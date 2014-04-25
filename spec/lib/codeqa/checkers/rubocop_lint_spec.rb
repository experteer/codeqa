require 'spec_helper'
begin
  require 'rubocop'
  describe Codeqa::Checkers::RubocopLint do
    it "should check text files" do
      source = source_with
      described_class.check?(source).should be_true
      source = source_with('', 'zipped.zip')
      described_class.check?(source).should be_false
    end

    it "should detect syntax errors" do
      source = source_with("class MyClass")
      checker = check_with(described_class, source)
      checker.should be_error
      checker.errors.details.first[1].should match(/unexpected token/)
    end

    it "should find not find if not there " do
      source = source_with("class MyClass; end")
      checker = check_with(described_class, source)
      checker.should be_success
    end

  end
rescue LoadError
  true #  skip rubocop specs
end
