require 'spec_helper'

describe Codeqa::Checkers::CheckRubySyntax do
  let (:checker_class) {
     Codeqa::Checkers::CheckRubySyntax
   }
  it "should check text files" do
    source=source_with
    checker_class.check?(source).should == true
    source=source_with('', 'zipped.zip')
    checker_class.check?(source).should == false
  end

  it "should detect syntax errors" do
    source=source_with("class MyClass")
    checker=check_with(checker_class, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "Ruby syntax error"]]
  end

  it "should find not find if not there " do
    source=source_with("class MyClass; end")
    checker=check_with(checker_class, source)
    checker.should be_success
  end

end