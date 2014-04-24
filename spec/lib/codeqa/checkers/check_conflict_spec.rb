require 'spec_helper'

describe Codeqa::Checkers::CheckConflict do
  it "should check text files" do
    source = source_with
    described_class.check?(source).should be == true
    source = source_with('', 'zipped.zip')
    described_class.check?(source).should be == false
  end

  it "should detect ======== and <<<<<<< and >>>>>>>" do
    source = source_with("first line\n<<<<<<<\n=======\nthirdline\n>>>>>>>")
    checker = check_with(described_class, source)
    checker.should be_error
    checker.errors.details.should be == [[nil, "conflict leftovers, please merge properly"]]
  end

  it "should find not find if not there " do
    source = source_with("first line\n<<<<<<\n======\nthirdline\n>>>>>>")
    checker = check_with(described_class, source)
    checker.should be_success
  end

end
