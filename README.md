# Codeqa

[![Gem Version](http://img.shields.io/gem/v/codeqa.svg?style=flat)](https://rubygems.org/gems/codeqa)
[![Build Status](http://img.shields.io/travis/experteer/codeqa.svg?style=flat)](https://travis-ci.org/experteer/codeqa)
[![Coverage Status](https://img.shields.io/coveralls/experteer/codeqa.svg?style=flat)](https://coveralls.io/r/experteer/codeqa)
[![Code Climate](http://img.shields.io/codeclimate/github/experteer/codeqa.svg?style=flat)](https://codeclimate.com/github/experteer/codeqa)

With codeqa you can check your code to comply to certain coding rules (utf8 only chars, indenting) or to avoid typical errors or
enforce deprecations. You might even put it into a pre commit hook.

## Installation

Add this line to your application's Gemfile:

    gem 'codeqa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install codeqa

## Usage

    codeqa filename


## Config

Since Version 0.3 codeqa uses ruby for configuration, therefore the config file
is now named `.codeqa.rb`. The loading of configuration files is still the same,
meaning we have to following load order:

1. Initialize with default settings (see `config/default.rb`)
2. load `.codeqa/config.rb` from your home directory and merge it with the defaults.
3. load `.codeqa/config.rb` placed in the project root, which is determined by finding
  the closest `.git` folder.

Both the config in your home directory and the project config file are optional
and will be automatically skiped if they do not exist.

Because codeqa now uses ruby for configuration we can more easily change settings
without replacing it completely.

### Example Config

```ruby
Codeqa.configure do |config|
  # override the list of excludes
  config.excludes = ['coverage/*',
                     'pkg/*',
                     'tmp/*',
                     /\.log/]

  # remove the default ruby lint in favor of rubocop
  config.enabled_checker.delete 'CheckRubySyntax'
  config.enabled_checker << 'RubocopLint'
  # also enable the rubocop autoformatter
  config.enabled_checker << 'RubocopFormatter'

  # add some more active formatters/cops to rubocop
  config.rubocop_formatter_cops << 'AlignHash'
  config.rubocop_formatter_cops << 'SignalException'
  config.rubocop_formatter_cops << 'DeprecatedClassMethods'
  config.rubocop_formatter_cops << 'RedundantBegin'
  config.rubocop_formatter_cops << 'RedundantSelf'
  config.rubocop_formatter_cops << 'RedundantReturn'
  config.rubocop_formatter_cops << 'CollectionMethods'
end
```

## Checkers

- pattern
  - CheckPry
  - CheckRspecFocus
  - CheckConflict
  - CheckStrangeChars
  - CheckLinkTo
- rubocop
  - RubocopLint (replacement for CheckRubySyntax)
  - RubocopFormatter
- erb
  - CheckErb (tests erb template for syntax errors using either `erb` or `action_view`
  - CheckErbHtml (removes all erb tags and tests with `tidy` if the template is valid XML)
  - HtmlValidator (uses Nokogiri to check stripped html.erb files against XML errors)
- yard
  - CheckYard (checks YARD for warnings)
- CheckRubySyntax (runs file though `ruby -c`, use RubocopLint if possible)

## Hooks
Since version 0.5 it's possible to run any scripts which are placed at .codeqa/hooks . If they exit with code <> 0
the commit is not allowed. The scripts have to be executable.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
