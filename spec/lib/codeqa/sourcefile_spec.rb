require 'spec_helper'

describe Codeqa::Sourcefile do
  it 'should detect binary' do
    source = Codeqa::Sourcefile.new('zipped.zip')
    expect(source).to be_binary
    expect(source).not_to be_text
  end

  it 'should detect ruby' do
    source = Codeqa::Sourcefile.new('ruby.rb')
    expect(source).to be_text
    expect(source).to be_ruby
  end

  it 'should detect erb' do
    source = Codeqa::Sourcefile.new('erb.erb')
    expect(source).to be_text
    expect(source).to be_erb
  end

  it 'should detect html' do
    source = Codeqa::Sourcefile.new('erb.html.erb')
    expect(source).to be_text
    expect(source).to be_erb
    expect(source).to be_html
    source = Codeqa::Sourcefile.new('erb.rhtml')
    expect(source).to be_text
    expect(source).to be_erb
    expect(source).to be_html
  end
end
