require 'rubygems'
require 'bundler/setup'

if ENV['CI']
  require 'simplecov'
  require 'codeclimate-test-reporter'

  CodeClimate::TestReporter.start
end

require 'minitest/autorun'
require 'minitest/pride'
require 'rails/all'
require 'rails/generators'
require 'rails/generators/test_case'

# Compatibility layer between MiniTest 4.x and MiniTest 5.x

Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

# Application for test purposes

class TestApp < Rails::Application
  config.active_support.deprecation = :log
  config.eager_load = false
end

TestApp.initialize!
