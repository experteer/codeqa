# Codeqa

[![Build Status](https://travis-ci.org/experteer/codeqa.svg?branch=master)](https://travis-ci.org/experteer/codeqa)
[![Coverage Status](https://img.shields.io/coveralls/experteer/codeqa.svg)](https://coveralls.io/r/experteer/codeqa)
[![Code Climate](https://codeclimate.com/github/experteer/codeqa/badges/gpa.svg)](https://codeclimate.com/github/experteer/codeqa)

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

The behavior of Codeqa can be controlled via the `.codeqa.yml` configuration
file. It makes it possible to enable/disable checker.
The configuration will be loaded in three steps:

1. Initialize with default settings (see `config/default.yml`)
2. load `.codeqa.yml` from your home directory and merge it with the defaults.
3. load `.codeqa.yml` placed in the project root, which is determined by finding
  the closest `.git` folder.

Both the config in your home directory and the project config file are optional
and will be automatically skiped if they do not exist.


## Todo

* rake task to check all checked in files of a repo

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
