require 'spec_helper'

describe Codeqa::CheckStrangeChars do
  it "should check text files" do
    source=source_with("", "file.html.erb")
    Codeqa::CheckStrangeChars.check?(source).should == true
    source=source_with('', 'zipped.zip')
    Codeqa::CheckStrangeChars.check?(source).should == false
  end

  it "should detect tabs" do
    source=source_with("one\x09two")
    checker=check_with(Codeqa::CheckStrangeChars, source)
    checker.should be_error
    checker.errors.details.should == [["1,4", "TAB x09 at line 1 column 4"]]
  end

  it "should detect form feeds" do
      source=source_with("one\n\x0ctwo")
      checker=check_with(Codeqa::CheckStrangeChars, source)
      checker.should be_error
      checker.errors.details.should == [["2,1", "FORM FEED x0C at line 2 column 1"]]
    end


end