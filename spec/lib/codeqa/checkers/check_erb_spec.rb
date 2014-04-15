require 'spec_helper'

describe Codeqa::Checkers::CheckErb do
  let (:checker_class) {
    Codeqa::Checkers::CheckErb
  }
  it "should check erb files" do
    source=source_with("", "file.html.erb")
    checker_class.check?(source).should == true
    source=source_with("", "test.rhtml")
    checker_class.check?(source).should == true
    source=source_with("", "test.text.html")
    checker_class.check?(source).should == true
    source=source_with('', 'zipped.zip')
    checker_class.check?(source).should == false
  end

  it "should detect syntax errors in the erb" do
    source=source_with("blub<%= def syntax %> ok")
    checker=check_with(checker_class, source)
    checker.should be_error
    str=checker.errors.details[0][1]

    str.should =~ Regexp.new(Regexp.escape("(erb):1: syntax error, unexpected end-of-input, expect"))
  end


end