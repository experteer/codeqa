require 'spec_helper'

describe Codeqa::Checkers::CheckLinkto do
  let (:checker_class) do
    Codeqa::Checkers::CheckLinkto
  end
  it "should check text files" do
    source = source_with
    checker_class.check?(source).should == true
    source = source_with('', 'zipped.zip')
    checker_class.check?(source).should == false
  end

  it "should detect <% link_to ... do ... %>" do
    source = source_with("<% link_to '/page',do_some_paths do%>")
    checker = check_with(checker_class, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "1 line(s) of old style block link_to"]]
  end

  it "should find not find if not there " do
    source = source_with("<%= link_to '/page',do_some_paths do%>")
    checker = check_with(checker_class, source)
    checker.should be_success
  end

end
