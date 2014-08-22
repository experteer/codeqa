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
    source = source_with('<div><ul></div>')
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([
      [1, 'Opening and ending tag mismatch: ul line 1 and div'],
      [1, 'Premature end of data in tag div line 1']
    ])
  end

  it 'should detect attribute till end of file errors' do
    source = source_with("<div class='halfopen></div>")
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([
      [1, "Unescaped '<' not allowed in attributes values"],
      [1, 'attributes construct error'],
      [1, "Couldn't find end of Start Tag div line 1"],
      [1, 'Extra content at the end of the document']
    ])
  end
  it 'should detect attribute with missing trailing qute mark' do
    source = source_with('<div class="halfopen next="ok"></div>')
    checker = check_with(described_class, source)
    expect(checker).to be_error
    expect(checker.errors.details).to eq([
      [1, 'attributes construct error'],
      [1, "Couldn't find end of Start Tag div line 1"],
      [1, 'Extra content at the end of the document']
    ])
  end

  it 'should find not find errors if html is ok ' do
    source = source_with('<div><ul></ul></div>')
    checker = check_with(described_class, source)
    expect(checker).to be_success
  end

  context 'javascript' do
    it 'should ignore javascript' do
      source = source_with('<div><script></ul></script></div>')
      checker = check_with(described_class, source)
      expect(checker).to be_success
    end
    it 'should ignore javascript' do
      source = source_with('<div><script type="text/javascript" charset="utf-8"></ul></script></div>')
      checker = check_with(described_class, source)
      expect(checker).to be_success
      source = source_with("<div><script>multiline\n</ul></script></div>")
      checker = check_with(described_class, source)
      expect(checker).to be_success
    end
    it 'should ignore javascript' do
      source = source_with('<div><style></ul></style></div>')
      checker = check_with(described_class, source)
      expect(checker).to be_success
    end
  end

  context 'erb' do
    let(:source) do
      source_with(
        IO.read(
          Codeqa.root.join('spec', 'fixtures', 'erb_example.html.erb')
        )
      )
    end

    it 'should use a stripped_html for validation' do
      checker = described_class.new(source)
      expect(checker).to receive(:stripped_html)
      checker.check
    end
    it 'should replace erb tags with html comments' do
      s = source_with('<div><% some ruby %></div>')
      checker = described_class.new(s)
      expect(checker.stripped_html).to eq('<div><!-- some ruby --></div>')
    end
    it 'should replace multiline erb tags' do
      checker = described_class.new(source)
      expect(checker.stripped_html).to eq(<<-EOF)
<div class="jobdetail">
  <!--= render :partial => 'header',
             :locals => @header_options.reverse_merge(
                     :position_presenter => @position_presenter,
                     :bookmark => @bookmark,
                     :account_id => @account.id,
                     :social_share => @social_share) if @position_presenter.show_header? -->
  <!--  if @position_presenter.internal_view? -->
      <!--= render :partial => 'intern',
                 :locals => @header_options.reverse_merge(
                         :position_presenter => @position_presenter,
                         :account_id => @account.id) -->
  <!-- else -->
      <iframe src="" scrolling="no">
      </iframe>
  <!-- end -->
</div>

<!--#
params:
@header_options
@account_id
@bookmark
@position
@position_presenter
-->
<!--removed script/style tag-->
EOF
    end
    it 'should be able to validate this stripped html' do
      checker = check_with(described_class, source)
      expect(checker).to be_success
    end
    it 'should only remove tags completely within quotes' do
      s = source_with '<%dont touch this%> before baz="bla <%=inside%> <%=inside2%> stuff" after'
      checker = described_class.new s
      expect(checker.stripped_html).to eq('<!--dont touch this--> before baz="bla  stuff" after')
    end
    it 'should also remove tags within single quotes' do
      s = source_with '<%dont touch this%> before baz="bla <%=inside + "text"%> <%=inside2%> stuff" after'
      checker = described_class.new s
      expect(checker.stripped_html).to eq('<!--dont touch this--> before baz="bla  stuff" after')
    end
  end
end
