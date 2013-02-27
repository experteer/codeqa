require 'spec_helper'

describe Codeqa::CheckErbHtml do
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

  it "should detect html tag errors" do
    source=source_with("<div><ul></div>")
    checker=check_with(Codeqa::CheckErbHtml, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "<div><ul></div>"],
                                      [nil, "line 1 column 10 - Error: unexpected </div> in <ul>\n"]]
  end

  it "should detect attribute till end of file errors" do
    source=source_with("<div class='halfopen></div>")
    checker=check_with(Codeqa::CheckErbHtml, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "<div class='halfopen></div>"],
                                      [nil, "line 1 column 28 - Warning: <div> end of file while parsing attributes\n"]]


  end
  it "should detect attribute with missing trailing qute mark" do
    source=source_with('<div class="halfopen next="ok"></div>')
    checker=check_with(Codeqa::CheckErbHtml, source)
    checker.should be_error
    checker.errors.details.should == [[nil, "<div class=\"halfopen next=\"ok\"></div>"],
                                      [nil, "line 1 column 1 - Warning: <div> attribute with missing trailing quote mark\n"]]


  end

  it "should find not find errors if html is ok " do
    source=source_with("<div><ul></ul></div>")
    checker=check_with(Codeqa::CheckErbHtml, source)
    checker.should be_success
  end


end