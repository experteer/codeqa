require 'spec_helper'

describe Codeqa::Checkers::CheckConflict do
  it "should check text files" do
    source = source_with
    described_class.check?(source).should be_true
    source = source_with('', 'zipped.zip')
    described_class.check?(source).should be_false
  end

  it "should detect ======== and <<<<<<< and >>>>>>>" do
    source = source_with("first line\n<<<<<<<\n=======\nthirdline\n>>>>>>>")
    checker = check_with(described_class, source)
    checker.should be_error
    checker.errors.details.should be == [
      ["2,1", "conflict leftovers in line 2, please merge properly"],
      ["3,1", "conflict leftovers in line 3, please merge properly"],
      ["5,1", "conflict leftovers in line 5, please merge properly"]
    ]
  end

  it "should find not find if not there " do
    source = source_with("first line\n<<<<<<\n======\nthirdline\n>>>>>>")
    checker = check_with(described_class, source)
    checker.should be_success
  end

end
