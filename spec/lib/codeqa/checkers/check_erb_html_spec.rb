require 'spec_helper'
# there is no tidy on travis-ci so we can't test this checker there
unless ENV['TRAVIS']
  describe Codeqa::Checkers::CheckErbHtml do
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
        [nil, '<div><ul></div>'],
        [nil, "line 1 column 10 - Error: unexpected </div> in <ul>\n"]])
    end

    it 'should detect attribute till end of file errors' do
      source = source_with("<div class='halfopen></div>")
      checker = check_with(described_class, source)
      expect(checker).to be_error
      expect(checker.errors.details).to eq([
        [nil, "<div class='halfopen></div>"],
        [nil, "line 1 column 28 - Warning: <div> end of file while parsing attributes\n"]])

    end
    it 'should detect attribute with missing trailing qute mark' do
      source = source_with('<div class="halfopen next="ok"></div>')
      checker = check_with(described_class, source)
      expect(checker).to be_error
      expect(checker.errors.details).to eq([
        [nil, "<div class=\"halfopen next=\"ok\"></div>"],
        [nil, "line 1 column 1 - Warning: <div> attribute with missing trailing quote mark\n"]])

    end

    it 'should find not find errors if html is ok ' do
      source = source_with('<div><ul></ul></div>')
      checker = check_with(described_class, source)
      expect(checker).to be_success
    end

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
end
