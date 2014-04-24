require 'spec_helper'

describe Codeqa::Sourcefile do
  it "should detect binary" do
    source = Codeqa::Sourcefile.new('zipped.zip')
    source.should be_binary
    source.should_not be_text
  end

  it "should detect ruby" do
    source = Codeqa::Sourcefile.new('ruby.rb')
    source.should be_text
    source.should be_ruby
  end

  it "should detect erb" do
    source = Codeqa::Sourcefile.new('erb.erb')
    source.should be_text
    source.should be_erb
  end

  it "should detect html" do
    source = Codeqa::Sourcefile.new('erb.html.erb')
    source.should be_text
    source.should be_erb
    source.should be_html
    source = Codeqa::Sourcefile.new('erb.rhtml')
    source.should be_text
    source.should be_erb
    source.should be_html
  end

end
