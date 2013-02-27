require 'spec_helper'

describe Codeqa::CheckErb do
  it "should check erb files" do
    source=source_with("", "file.html.erb")
    Codeqa::CheckErbHtml.check?(source).should == true
    source=source_with("", "test.rhtml")
    Codeqa::CheckErbHtml.check?(source).should == true
    source=source_with("", "test.text.html")
    Codeqa::CheckErbHtml.check?(source).should == true
    source=source_with('', 'zipped.zip')
    Codeqa::CheckErbHtml.check?(source).should == false
  end

  it "should detect syntax errors in the erb" do
    source=source_with("blub<%= def syntax %> ok")
    checker=check_with(Codeqa::CheckErb, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "compile error\n(erb):1: syntax error, unexpected ')', expecting '\\n' or ';'\n... _erbout.concat(( def syntax ).to_s); _erbout.concat \" ok\"; ...\n                              ^\n(erb):1"]]
  end


end