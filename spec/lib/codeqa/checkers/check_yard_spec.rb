require 'spec_helper'

describe Codeqa::Checkers::CheckYard do
  let (:checker_class) do
    Codeqa::Checkers::CheckYard
  end
  it "should check rb files" do
    source = source_with("", "file.rb")
    checker_class.check?(source).should == true
    source = source_with("", "test.rhtml")
    checker_class.check?(source).should == false
  end

  it "should detect yard errors" do
    source = source_with("# @paramsssss\nclass MyClass\nend")
    checker = check_with(checker_class, source)
    checker.should be_error
    detail = checker.errors.details[0][1]
    detail.should match(/Unknown tag @paramsssss in file/)
  end

end
