require 'bundler/gem_tasks'
require 'rake/testtask'
require 'appraisal'

Rake::TestTask.new(:test) do |t|
  t.libs = %w(lib test)
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task default: :test
