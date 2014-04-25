require 'spec_helper'

describe Codeqa::Checkers::CheckPry do
  it "should check ruby files" do
    source = source_with('', 'file.rb')
    described_class.check?(source).should be_true
    source = source_with('', 'zipped.zip')
    described_class.check?(source).should be_false
  end

  it "should detect binding.pry" do
    source = source_with("first line\nbinding.pry\nthirdline", 'file.rb')
    checker = check_with(described_class, source)
    checker.should be_error
  end

  it "should be success is all is finde " do
    source = source_with("first line\nthirdline\n", 'file.rb')
    checker = check_with(described_class, source)
    checker.should be_success
  end

end
