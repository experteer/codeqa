Codeqa.configure do |config|
  config.excludes = ['spec/fixtures/html_error.html.erb',
                     'spec/fixtures/html_error.text.html',
                     'spec/fixtures/ruby_error.rb',
                     'lib/codeqa/checkers/check_pry.rb',
                     'spec/lib/codeqa/checkers/check_pry_spec.rb',
                     'spec/lib/codeqa/checkers/check_rspec_focus_spec.rb']

  config.enabled_checker.delete 'CheckRubySyntax'
  config.enabled_checker << 'RubocopLint'
  config.enabled_checker << 'RubocopFormatter'

  config.rubocop_formatter_cops << 'AlignHash'
  config.rubocop_formatter_cops << 'SignalException'
  config.rubocop_formatter_cops << 'DeprecatedClassMethods'
  config.rubocop_formatter_cops << 'RedundantBegin'
  config.rubocop_formatter_cops << 'RedundantSelf'
  config.rubocop_formatter_cops << 'RedundantReturn'
  config.rubocop_formatter_cops << 'CollectionMethods'
end
