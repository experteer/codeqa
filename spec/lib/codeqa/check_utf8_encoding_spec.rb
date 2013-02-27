require 'spec_helper'

describe Codeqa::CheckConflict do
  it "should check text files" do
    source=source_with
    Codeqa::CheckConflict.check?(source).should == true
    source=source_with('', 'zipped.zip')
    Codeqa::CheckConflict.check?(source).should == false
  end

  it "should detect ======== and <<<<<<< and >>>>>>>" do
    source=source_with("first line\n<<<<<<<\n=======\nthirdline\n>>>>>>>")
    checker=check_with(Codeqa::CheckConflict, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "3 line(s) of conflict leftovers"]]
  end

  it "should find not find if not there " do
    source=source_with("first line\n<<<<<<\n======\nthirdline\n>>>>>>")
    checker=check_with(Codeqa::CheckConflict, source)
    checker.should be_success
  end

end