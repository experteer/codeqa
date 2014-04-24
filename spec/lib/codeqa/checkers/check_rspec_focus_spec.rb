require 'spec_helper'

describe Codeqa::Checkers::CheckRspecFocus do
  it "should check spec files" do
    source = source_with('', 'file_spec.rb')
    described_class.check?(source).should be_true
    source = source_with('', 'file.rb')
    described_class.check?(source).should be_false
  end

  it "should detect binding.pry" do
    source = source_with("first line\:focus\nthirdline", 'file_spec.rb')
    checker = check_with(described_class, source)
    checker.should be_error
  end

  it "should be success is all is finde " do
    source = source_with("first line\nthirdline\n", 'file_spec.rb')
    checker = check_with(described_class, source)
    checker.should be_success
  end

end
