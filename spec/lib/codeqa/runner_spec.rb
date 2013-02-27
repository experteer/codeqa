require 'spec_helper'

describe Codeqa::CheckUtf8Encoding do
  it "should check non binary files" do
    source=source_with("", "file.zip")
    Codeqa::CheckUtf8Encoding.check?(source).should == false
    source=source_with("", "test.rhtml")
    Codeqa::CheckUtf8Encoding.check?(source).should == true
  end

  it "should pass if utf8" do
    source=source_with("some utf8 stuff: äöößↈ")
    checker=check_with(Codeqa::CheckUtf8Encoding, source)
    checker.should be_success
  end

  it "should not pass if not utf8" do
    source=source_with("some special latin1 stuff:\xf4")
    checker=check_with(Codeqa::CheckUtf8Encoding, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "compile error\n(erb):1: syntax error, unexpected ')', expecting '\\n' or ';'\n... _erbout.concat(( def syntax ).to_s); _erbout.concat \" ok\"; ...\n                              ^\n(erb):1"]]
  end
end