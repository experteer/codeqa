require 'spec_helper'

describe Codeqa::Checkers::CheckUtf8Encoding do
  it_behaves_like 'a checker'

  it 'should check text files' do
    source = source_with
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'zipped.zip')
    expect(described_class.check?(source)).to be_falsey
  end

  it 'should detect non utf8 chars ' do
    source = source_with("\xE4\xF6\xFC")
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([[nil, 'encoding error, not utf8']])
  end

  it 'should find not find if not there ' do
    source = source_with('first line')
    checker = check_with(described_class, source)
    expect(checker).to be_success
  end

end
