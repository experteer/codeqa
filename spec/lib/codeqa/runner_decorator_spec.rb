require 'spec_helper'

describe Codeqa::RunnerDecorator do
  let(:errors){ Codeqa::CheckErrors.new }
  let(:decorator) do
    checker = double(Codeqa::Checker, :errors => errors,
                                      :name   => 'test',
                                      :hint   => 'testtest')
    runner = double(Codeqa::Runner, :failures   => [checker],
                                    :sourcefile => Codeqa::Sourcefile.new('foo.rb', 'foo'),
                                    :success?   => false)
    Codeqa::RunnerDecorator.new(runner)
  end

  it 'should format error as line if number given' do
    errors.add(77, 'test message')
    expect(decorator.details_to_s).to eq(<<-EOF)
Line: \e[33m77\e[0m|test message
EOF
  end

  it 'should format error as position if array given' do
    errors.add([22, 77], 'test message')
    expect(decorator.details_to_s).to eq(<<-EOF)
Pos: \e[33m22,77\e[0m|test message
EOF
  end

  it 'should simply print error content if no context is given' do
    errors.add(nil, 'test message')
    expect(decorator.details_to_s).to eq(<<-EOF)
test message
EOF
  end

  it 'should format error as source if :source token given' do
    errors.add(:source, 'test message')
    expect(decorator.details_to_s).to eq(<<-EOF)
\e[33m  1\e[0m|test message
EOF
  end

  it 'should correctly format multiline source' do
    errors.add(:source, "test message\nline two\nthird\n\nfifth")
    expect(decorator.details_to_s).to eq(<<-EOF)
\e[33m  1\e[0m|test message
\e[33m  2\e[0m|line two
\e[33m  3\e[0m|third
\e[33m  4\e[0m|
\e[33m  5\e[0m|fifth
EOF
  end
  # it 'should run provide the errors if the checker failed' do
  #   source = source_with('def syntax_error', 'ruby.rb')
  #   runner = Codeqa::Runner.run(source)
  #   expect(runner.success?).to be false
  #   decorator = Codeqa::RunnerDecorator.new(runner)
  #   expect(decorator.to_s).to match(/syntax/)
  # end
  # it 'should run list the ran checkers' do
  #   source = source_with('def foo; end', 'ruby.rb')
  #   runner = Codeqa::Runner.run(source)
  #   expect(runner.success?).to be true
  #   decorator = Codeqa::RunnerDecorator.new(runner)
  #   expect(decorator.to_s).to match(/Passed tests.+strange chars/)
  # end
end
