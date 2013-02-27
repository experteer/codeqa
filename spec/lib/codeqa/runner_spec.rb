require 'spec_helper'

describe Codeqa::Runner do
  it "should have some matching checkers for ruby files" do
    runner=Codeqa::Runner.new(source_with)
    runner.matching_checkers.should include(Codeqa::CheckConflict)
    runner.matching_checkers.should_not include(Codeqa::CheckErb)
  end

  it "should run the matching_checkers" do
    source=source_with("def syntax_error")
    runner=Codeqa::Runner.run(source)
    runner.results.should_not be_empty
  end
end