require 'spec_helper'

describe Codeqa::Checkers::CheckLinkto do
  it "should check erb files" do
    source = source_with('','file.html.erb')
    described_class.check?(source).should be_true
    source = source_with('', 'zipped.zip')
    described_class.check?(source).should be_false
  end

  it "should detect <% link_to ... do ... %>" do
    source = source_with("<% link_to '/page',do_some_paths do%>",'file.html.erb')
    checker = check_with(described_class, source)
    checker.should be_error
    checker.errors.details.should be == [["1,1", "old style block link_to in line 1"]]
  end

  it "should find not find if not there " do
    source = source_with("<%= link_to '/page',do_some_paths do%>",'file.html.erb')
    checker = check_with(described_class, source)
    checker.should be_success
  end

end
