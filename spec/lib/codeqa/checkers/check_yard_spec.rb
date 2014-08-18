require 'spec_helper'

describe Codeqa::Checkers::CheckYard do
  it_behaves_like 'a checker'

  it 'should check rb files' do
    source = source_with('', 'file.rb')
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'test.rhtml')
    expect(described_class.check?(source)).to be_falsey
  end

  it 'should detect yard errors' do
    source = source_with("# @paramsssss\nclass MyClass\nend", 'file.rb')
    checker = check_with(described_class, source)
    expect(checker).to be_error
    detail = checker.errors.details[0][1]
    expect(detail).to match(/Unknown tag @paramsssss in file/)
  end

end
