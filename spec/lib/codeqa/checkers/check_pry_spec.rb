require 'spec_helper'

describe Codeqa::Checkers::CheckPry do
  it_behaves_like 'a checker'

  it 'should check ruby files' do
    source = source_with('', 'file.rb')
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'zipped.zip')
    expect(described_class.check?(source)).to be_falsey
  end

  it 'should detect binding pry' do
    source = source_with("first line\nbinding.pry\nthirdline", 'file.rb')
    checker = check_with(described_class, source)
    expect(checker).to be_error
  end

  it 'should be success is all is finde ' do
    source = source_with("first line\nthirdline\n", 'file.rb')
    checker = check_with(described_class, source)
    expect(checker).to be_success
  end

end
