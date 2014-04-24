require 'spec_helper'

describe Codeqa::Sourcefile do
  it "should detect binary" do
    source = Codeqa::Sourcefile.new('zipped.zip')
    source.attributes['binary'].should be == true
    source.attributes['text'].should be == false
  end

  it "should detect ruby" do
    source = Codeqa::Sourcefile.new('ruby.rb')
    source.attributes['text'].should be == true
    source.attributes['language'].should be == 'ruby'
  end

  it "should detect erb" do
    source = Codeqa::Sourcefile.new('erb.erb')
    source.attributes['text'].should be == true
    source.attributes['eruby'].should be == true
  end

  it "should detect html" do
    source = Codeqa::Sourcefile.new('erb.html.erb')
    source.attributes['text'].should be == true
    source.attributes['eruby'].should be == true
    source.attributes['language'].should be == 'html'
    source = Codeqa::Sourcefile.new('erb.rhtml')
    source.attributes['text'].should be == true
    source.attributes['eruby'].should be == true
    source.attributes['language'].should be == 'html'
  end

end
