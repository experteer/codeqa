require 'spec_helper'

describe Codeqa::Checkers::CheckConflict do
  let (:checker_class) {
    Codeqa::Checkers::CheckConflict
  }

  it "should check text files" do
    source=source_with
    checker_class.check?(source).should == true
    source=source_with('', 'zipped.zip')
    checker_class.check?(source).should == false
  end

  it "should detect ======== and <<<<<<< and >>>>>>>" do
    source=source_with("first line\n<<<<<<<\n=======\nthirdline\n>>>>>>>")
    checker=check_with(checker_class, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "conflict leftovers, please merge properly"]]
  end

  it "should find not find if not there " do
    source=source_with("first line\n<<<<<<\n======\nthirdline\n>>>>>>")
    checker=check_with(checker_class, source)
    checker.should be_success
  end


end