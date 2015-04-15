require 'spec_helper'
require 'nokogiri'

describe Codeqa::ErbSanitizer do
  context 'erb' do
    # let(:source) do
    #   source_with(
    #     IO.read(
    #       Codeqa.root.join('spec', 'fixtures', 'erb_example.html.erb')
    #     )
    #   )
    # end
    def compile(content)
      described_class.new(content).result
    end

    it 'should remove erb tags' do
      source = '<div><% some ruby %></div>'
      expected = '<div></div>'
      doc = compile(source)
      expect(doc).to eq(expected)
      expect(Nokogiri::XML(doc).errors).to be_empty
    end
    it 'should remove erb tags within attributes' do
      source = '<div <%dont touch this%> baz="bla <%=inside%> <%=inside2%> stuff" after="meh"></div>'
      expected = '<div  baz="bla   stuff" after="meh"></div>'
      doc = compile(source)
      expect(doc).to eq(expected)
      expect(Nokogiri::XML(doc).errors).to be_empty
    end
    it 'should properly remove multiline erb tags and keep the correct line numbers' do
      source = <<-EOR
<div>
<% render :partial => :foo, :locals => { :foo => 'foo',
                                         :bar => 'bar'
                                         :baz => 'baz' }%>
</div>
EOR
      expected = <<-EOR
<div>



</div>
EOR
      doc = compile(source)
      expect(doc).to eq(expected)
      expect(Nokogiri::XML(doc).errors).to be_empty
    end

    it 'should work on a more difficult example' do
      source = IO.read(Codeqa.root.join('spec', 'fixtures', 'erb_example.html.erb'))
      expected = IO.read(Codeqa.root.join('spec', 'fixtures', 'erb_example.html'))
      doc = compile(source)
      expect(doc).to eq(expected)
      expect(Nokogiri::XML(doc).errors).to be_empty
    end
  end
end
