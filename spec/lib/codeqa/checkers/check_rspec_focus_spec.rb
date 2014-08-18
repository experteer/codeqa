require 'spec_helper'

describe Codeqa::Checkers::CheckRspecFocus do
  it_behaves_like 'a checker'

  it 'should check spec files' do
    source = source_with('', 'file_spec.rb')
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'file.rb')
    expect(described_class.check?(source)).to be_falsey
  end

  it 'should detect :focus' do
    source = source_with("first line\:focus\nthirdline", 'file_spec.rb')
    checker = check_with(described_class, source)
    expect(checker).to be_error
  end

  it 'should be success is all is finde ' do
    source = source_with("first line\nthirdline\n", 'file_spec.rb')
    checker = check_with(described_class, source)
    expect(checker).to be_success
  end

end
