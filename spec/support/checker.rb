RSpec.shared_examples 'a checker' do
  let(:checker){ described_class.new(double('SourceFile', :null_object => true)) }
  %i(name hint check).each do |method|
    it "should respond to :#{method}" do
      expect(checker).to respond_to(method)
    end
  end
  %i(name hint).each do |method|
    it "should return a non empty string from :#{method}" do
      expect(checker.send(method)).not_to be_empty
    end
  end
  context 'ClassMethods' do
    %i(check? available?).each do |method|
      it "should respond to :#{method}" do
        expect(described_class).to respond_to(method)
      end
    end
  end
end
