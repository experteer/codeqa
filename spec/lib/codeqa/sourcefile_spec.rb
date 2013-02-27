require 'spec_helper'

describe Codeqa::Sourcefile do
  it "should detect binary" do
    source=Codeqa::Sourcefile.new('zipped.zip')
    source.attributes['binary'].should == true
    source.attributes['text'].should == false
  end

  it "should detect ruby" do
    source=Codeqa::Sourcefile.new('ruby.rb')
    source.attributes['text'].should == true
    source.attributes['language'].should == 'ruby'
  end

  it "should detect erb" do
    source=Codeqa::Sourcefile.new('erb.erb')
    source.attributes['text'].should == true
    source.attributes['eruby'].should == true
  end

  it "should detect html" do
    source=Codeqa::Sourcefile.new('erb.html.erb')
    source.attributes['text'].should == true
    source.attributes['eruby'].should == true
    source.attributes['language'].should == 'html'
    source=Codeqa::Sourcefile.new('erb.rhtml')
    source.attributes['text'].should == true
    source.attributes['eruby'].should == true
    source.attributes['language'].should == 'html'
  end

end