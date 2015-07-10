require 'spec_helper'

describe Codeqa::Checkers::CheckConflict do
  it_behaves_like 'a checker'

  it 'should check text files' do
    source = source_with
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'zipped.zip')
    expect(described_class.check?(source)).to be_falsey
  end

  it 'should detect ======== and <<<<<<< and >>>>>>>' do
    source = source_with("first line\n<<<<<<<\n=======\nthirdline\n>>>>>>>")
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([
      [[2, 1], 'conflict leftovers in line 2, please merge properly'],
      [[3, 1], 'conflict leftovers in line 3, please merge properly'],
      [[5, 1], 'conflict leftovers in line 5, please merge properly']
    ])
  end

  it 'should find not find if not there ' do
    source = source_with("first line\n<<<<<<\n======\nthirdline\n>>>>>>")
    checker = check_with(described_class, source)
    expect(checker).to be_success
  end
end
