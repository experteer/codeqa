require 'spec_helper'

describe Codeqa::Checkers::CheckStrangeChars do
  it_behaves_like 'a checker'

  it 'should check text files' do
    source = source_with('', 'file.html.erb')
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'zipped.zip')
    expect(described_class.check?(source)).to be_falsey
  end

  it 'should detect tabs' do
    source = source_with("one\x09two")
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([['1,4', 'TAB x09 at line 1 column 4']])
  end

  it 'should detect form feeds' do
    source = source_with("one\n\x0ctwo")
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([['2,1', 'FORM FEED x0C at line 2 column 1']])
  end

end
