require 'spec_helper'
describe Codeqa::Checkers::HtmlValidator do
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

  it 'should detect html tag errors' do
    text = '<div><ul></div>'
    source = source_with(text)
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([
      [:source, text],
      [1, 'Opening and ending tag mismatch: ul line 1 and div']
    ])
  end

  it 'should detect attribute till end of file errors' do
    text = "<div class='halfopen></div>"
    source = source_with(text)
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([
      [:source, text],
      [1, "Unescaped '<' not allowed in attributes values"],
      [1, 'attributes construct error'],
      [1, "Couldn't find end of Start Tag div line 1"]
    ])
  end
  it 'should detect attribute with missing trailing qute mark' do
    text = '<div class="halfopen next="ok"></div>'
    source = source_with(text)
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([
      [:source, text],
      [1, 'attributes construct error'],
      [1, "Couldn't find end of Start Tag div line 1"]
    ])
  end

  it 'should find not find errors if html is ok ' do
    source = source_with('<div><ul></ul></div>')
    checker = check_with(described_class, source)
    expect(checker).to be_success
  end
  it "should no complain about nbsp 'spaces'" do
    source = source_with('<div>something&nbsp;fooo</div>')
    checker = check_with(described_class, source)
    expect(checker).to be_success
  end

  # context 'javascript' do
  #   it 'should ignore javascript' do
  #     source = source_with('<div><script></ul></script></div>')
  #     checker = check_with(described_class, source)
  #     expect(checker).to be_success
  #   end
  #   it 'should ignore javascript' do
  #     source = source_with('<div><script type="text/javascript" charset="utf-8"></ul></script></div>')
  #     checker = check_with(described_class, source)
  #     expect(checker).to be_success
  #     source = source_with("<div><script>multiline\n</ul></script></div>")
  #     checker = check_with(described_class, source)
  #     expect(checker).to be_success
  #   end
  #   it 'should ignore javascript' do
  #     source = source_with('<div><style></ul></style></div>')
  #     checker = check_with(described_class, source)
  #     expect(checker).to be_success
  #   end
  # end
end
