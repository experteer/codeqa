require 'spec_helper'

describe Codeqa::RunnerDecorator do
  it 'should run provide the errors if the checker failed' do
    source = source_with('def syntax_error', 'ruby.rb')
    runner = Codeqa::Runner.run(source)
    expect(runner.success?).to be false
    decorator = Codeqa::RunnerDecorator.new(runner)
    expect(decorator.to_s).to match(/syntax/)
  end
  it 'should run list the ran checkers' do
    source = source_with('def foo; end', 'ruby.rb')
    runner = Codeqa::Runner.run(source)
    expect(runner.success?).to be true
    decorator = Codeqa::RunnerDecorator.new(runner)
    expect(decorator.to_s).to match(/Passed tests.+strange chars/)
  end

end
