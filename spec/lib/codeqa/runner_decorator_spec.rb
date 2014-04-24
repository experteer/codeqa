require 'spec_helper'

describe Codeqa::RunnerDecorator do
  it "should run the matching_checkers" do
    source = source_with("def syntax_error", "ruby.rb")
    runner = Codeqa::Runner.run(source)
    runner.should_not be_success
    decorator = Codeqa::RunnerDecorator.new(runner)
    # decorator.to_s.should match(/ruby syntax/)
    decorator.to_s.should match(/rubocop lint/)
  end
end
