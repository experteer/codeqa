#!/usr/bin/env ruby
require 'pathname'

APP_ROOT=Pathname.new(File.expand_path(File.join(File.dirname(__FILE__),'..','..')))
HOOKS_PATH=APP_ROOT.join('.codeqa','hooks')


#run each hook if one gives an error then commit will fail

HOOKS_PATH.children(false).sort.each do |filename|
  exe=HOOKS_PATH.join(filename)
  ok=system(%{#{exe} APP_ROOT="#{APP_ROOT}"})
  exit 1 unless ok
end

exit 0
