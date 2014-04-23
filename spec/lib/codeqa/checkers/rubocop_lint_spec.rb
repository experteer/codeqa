require 'spec_helper'

describe Codeqa::Checkers::RubocopLint do
  it "should check text files" do
    source=source_with
    described_class.check?(source).should == true
    source=source_with('', 'zipped.zip')
    described_class.check?(source).should == false
  end

  it "should detect syntax errors" do
    source=source_with("class MyClass")
    checker=check_with(described_class, source)
    checker.should be_error
    checker.errors.details.first[1].should match(/unexpected token/)
  end

  it "should find not find if not there " do
    source=source_with("class MyClass; end")
    checker=check_with(described_class, source)
    checker.should be_success
  end

end