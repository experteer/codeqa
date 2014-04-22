require 'spec_helper'

describe Codeqa::Checkers::CheckStrangeChars do
  let (:checker_class) do
     Codeqa::Checkers::CheckStrangeChars
   end
  it "should check text files" do
    source = source_with("", "file.html.erb")
    checker_class.check?(source).should be == true
    source = source_with('', 'zipped.zip')
    checker_class.check?(source).should be == false
  end

  it "should detect tabs" do
    source = source_with("one\x09two")
    checker = check_with(checker_class, source)
    checker.should be_error
    checker.errors.details.should be == [["1,4", "TAB x09 at line 1 column 4"]]
  end

  it "should detect form feeds" do
      source = source_with("one\n\x0ctwo")
      checker = check_with(checker_class, source)
      checker.should be_error
      checker.errors.details.should be == [["2,1", "FORM FEED x0C at line 2 column 1"]]
    end

end
