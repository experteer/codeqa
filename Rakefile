require 'bundler/gem_tasks'

desc 'Run all specs'
task :specs do
  opts = %w(rspec -c)
  opts += ['--require', File.join(File.dirname(__FILE__), 'spec', 'spec_helper')]
  # opts += ['-I', YARD::ROOT]
  if ENV['DEBUG']
    $DEBUG = true
    opts += ['-d']
  end
  opts += FileList['spec/**/*_spec.rb'].sort
  cmd = opts.join(' ')
  puts cmd if Rake.application.options.trace
  system(cmd)
  raise "Command failed with status (#{$?.to_i}): #{cmd}" if $?.to_i != 0
end
task :spec => :specs
task :default => :specs
