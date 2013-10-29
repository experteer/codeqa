require 'spec_helper'

describe Codeqa::CheckLinkto do
  it "should check text files" do
    source=source_with
    Codeqa::CheckLinkto.check?(source).should == true
    source=source_with('', 'zipped.zip')
    Codeqa::CheckLinkto.check?(source).should == false
  end

  it "should detect <% link_to ... do ... %>" do
    source=source_with("<% link_to '/page',do_some_paths do%>")
    checker=check_with(Codeqa::CheckLinkto, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "1 line(s) of old style block link_to"]]
  end

  it "should find not find if not there " do
    source=source_with("<%= link_to '/page',do_some_paths do%>")
    checker=check_with(Codeqa::CheckLinkto, source)
    checker.should be_success
  end


end