require 'spec_helper'

describe Codeqa::Checkers::CheckLinkto do
  it_behaves_like 'a checker'

  it 'should check erb files' do
    source = source_with('', 'file.html.erb')
    expect(described_class.check?(source)).to be_truthy
    source = source_with('', 'zipped.zip')
    expect(described_class.check?(source)).to be_falsey
  end

  it 'should detect <% link_to ... do ... %>' do
    source = source_with("<% link_to '/page',do_some_paths do%>", 'file.html.erb')
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([['1,1', 'old style block link_to in line 1']])
  end

  it 'should find not find if not there ' do
    source = source_with("<%= link_to '/page',do_some_paths do%>", 'file.html.erb')
    checker = check_with(described_class, source)
    expect(checker).to be_success
  end

end
