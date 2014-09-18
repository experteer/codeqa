# -*- encoding: utf-8 -*-
require File.expand_path('../lib/codeqa/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Peter Schrammel', 'Andreas Eger']
  gem.email         = ['peter.schrammel@experteer.com', 'dev@eger-andreas.de']
  gem.description   = 'Checks your code (esp Rails) for common errors'
  gem.summary       = 'Code checker'
  gem.homepage      = 'https://github.com/experteer/codeqa'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'codeqa'
  gem.require_paths = ['lib']
  gem.version       = Codeqa::VERSION

  gem.required_ruby_version = '>= 2.0'

  gem.add_dependency 'multi_json', '>= 1.0'
  gem.add_dependency 'colorize', '>= 0.7'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '>=3.0'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'nokogiri'
  gem.add_development_dependency 'rubocop'
end
