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

  context 'script tags' do
    it 'should replace script tags with html comment' do
      text = '<div><script>foo</script></div>'
      source = source_with(text)
      checker = described_class.new(source)
      expect(checker.stripped_html).to eq('<div><!-- script /script --></div>')
    end

    it 'should replace multiline script tags while keeping the linecount correct' do
      text = <<-EOR
<div>
  <script>
    var some = 'javascript';
    console.log(some);
  </script>
</div>
EOR
      source = source_with(text)
      checker = described_class.new(source)
      expect(checker.stripped_html).to eq(<<-EOR)
<div>
  <!-- script


 /script -->
</div>
EOR
    end
    it 'should replace script tags when there are multiple script tags in the text' do
      text = <<-EOR
<div>
  <script>
    var some = 'javascript';
  </script>
  content
  <script>
    console.log(some);
  </script>
</div>
EOR
      source = source_with(text)
      checker = described_class.new(source)
      expect(checker.stripped_html).to eq(<<-EOR)
<div>
  <!-- script

 /script -->
  content
  <!-- script

 /script -->
</div>
EOR
    end
  end
end
