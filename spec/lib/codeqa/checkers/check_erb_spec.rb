require 'spec_helper'

describe Codeqa::Checkers::CheckErb do
  it_behaves_like 'a checker'

  it 'should check erb files' do
    source = source_with('', 'file.html.erb')
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'test.rhtml')
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'test.text.html')
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'zipped.zip')
    expect(described_class.check?(source)).to be_falsey
  end

  it 'should detect syntax errors in the erb' do
    source = source_with('blub<%= def syntax %> ok')
    checker = check_with(described_class, source)
    expect(checker.errors?).to be true
    str = checker.errors.details[0][1]

    expect(str).to match(Regexp.new(Regexp.escape('(erb):1: syntax error, unexpected end-of-input, expect')))
  end
  it 'should be successfull for valid erb' do
    source = source_with('blub<%= var %> ok')
    checker = check_with(described_class, source)
    expect(checker.success?).to be true
  end

end
