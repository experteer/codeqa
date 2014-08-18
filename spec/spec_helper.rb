require 'simplecov'
SimpleCov.start

require 'codeqa'
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # override some config settings
  config.before(:all) do
    load_test_config
  end
end

Dir['./spec/support/**/*.rb'].sort.each{ |f| require f }

def load_test_config
  Codeqa.configure do |c|
    c.excludes = ['vendor/**/*']
    c.enabled_checker = %w(CheckStrangeChars
                           CheckUtf8Encoding
                           CheckConflict
                           CheckPry
                           RubocopLint)
    c.rubocop_formatter_cops = %w(EmptyLinesAroundBody
                                  EmptyLines
                                  TrailingWhitespace)
    c.erb_engine = 'erb'
  end
end

def check_with(klass, source)
  checker = klass.new(source)
  checker.check
  checker
end

def source_with(content='#ruby file', filename='prog.rb')
  Codeqa::Sourcefile.new(filename, content)
end
