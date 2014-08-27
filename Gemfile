source 'https://rubygems.org'

# Specify your gem's dependencies in codeqa.gemspec
gemspec

group :development do
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rb-inotify', :require => false
  # gem 'rb-fsevent', :require => false #mac only
  # gem 'rb-fchange', :require => false #windows only
end

group :development, :test do
  gem 'pry-byebug', :platform => :mri
end

group :test do
  gem 'simplecov', :require => false
  gem 'coveralls', :require => false
end
