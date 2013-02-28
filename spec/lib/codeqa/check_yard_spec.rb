require 'spec_helper'

describe Codeqa::CheckYard do
  it "should check rb files" do
    source=source_with("", "file.rb")
    Codeqa::CheckYard.check?(source).should == true
    source=source_with("", "test.rhtml")
    Codeqa::CheckYard.check?(source).should == false
  end

  it "should detect yard errors" do
    source=source_with("# @paramsssss\nclass MyClass\nend")
    checker=check_with(Codeqa::CheckYard, source)
    checker.should be_error
    detail=checker.errors.details[0][1]
    detail.should match(/Unknown tag @paramsssss in file/)
  end


end