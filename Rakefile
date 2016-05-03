require 'bundler/gem_tasks'
require 'rake/testtask'
require 'appraisal'

Rake::TestTask.new(:test) do |t|
  t.libs = %w(railspack spec)
  t.pattern = 'spec/*_spec.rb'
end

task default: :test
