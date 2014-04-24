require 'spec_helper'

describe Codeqa::Checkers::CheckErb do
  it "should check erb files" do
    source = source_with("", "file.html.erb")
    described_class.check?(source).should be == true
    source = source_with("", "test.rhtml")
    described_class.check?(source).should be == true
    source = source_with("", "test.text.html")
    described_class.check?(source).should be == true
    source = source_with('', 'zipped.zip')
    described_class.check?(source).should be == false
  end

  it "should detect syntax errors in the erb" do
    source = source_with("blub<%= def syntax %> ok")
    checker = check_with(described_class, source)
    checker.should be_error
    str = checker.errors.details[0][1]

    str.should =~ Regexp.new(Regexp.escape("(erb):1: syntax error, unexpected end-of-input, expect"))
  end

end
