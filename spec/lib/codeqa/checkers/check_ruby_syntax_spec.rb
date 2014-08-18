require 'spec_helper'

describe Codeqa::Checkers::CheckRubySyntax do
  it_behaves_like 'a checker'

  it 'should check text files' do
    source = source_with
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'zipped.zip')
    expect(described_class.check?(source)).to be_falsey
  end

  it 'should detect syntax errors' do
    source = source_with('class MyClass')
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([[nil, 'Ruby syntax error']])
  end

  it 'should find not find if not there ' do
    source = source_with('class MyClass; end')
    checker = check_with(described_class, source)
    expect(checker).to be_success
  end

end
