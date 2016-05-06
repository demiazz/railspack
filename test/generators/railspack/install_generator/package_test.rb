require 'test_helper'
require 'yaml'
require 'json'
require 'generators/railspack/install_generator'

class RailspackGeneratorsInstallPackageTest < Rails::Generators::TestCase
  include Railspack::TestSupport::Generator

  tests Railspack::Generators::InstallGenerator

  def test_generate_a_package_json
    run_generator

    assert_file 'package.json'
  end

  def test_package_json_contains_application_name
    run_generator

    assert_file 'package.json' do |content|
      package = JSON.parse(content)
      name = Rails.application.class.name.underscore.dasherize

      assert_equal package['name'], name
    end
  end

  def test_package_json_contains_version
    run_generator

    assert_file 'package.json' do |content|
      package = JSON.parse(content)

      assert_equal package['version'], '1.0.0'
    end
  end

  def test_package_json_contains_private_flag
    run_generator

    assert_file 'package.json' do |content|
      package = JSON.parse(content)

      assert_equal package['private'], true
    end
  end

  def test_package_json_contains_webpack_as_dependencies
    run_generator

    assert_file 'package.json' do |content|
      dev_deps = JSON.parse(content)['devDependencies']

      assert_equal dev_deps['webpack'], '1.13.0'
      assert_equal dev_deps['webpack-dev-server'], '1.14.1'
    end
  end
end
