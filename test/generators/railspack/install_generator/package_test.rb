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

  def test_package_json_contains_babel_as_dependencies
    run_generator

    assert_file 'package.json' do |content|
      dev_deps = JSON.parse(content)['devDependencies']

      assert_equal dev_deps['babel-core'], '6.8.0'
      assert_equal dev_deps['babel-register'], '6.8.0'
      assert_equal dev_deps['babel-preset-es2015'], '6.6.0'
      assert_equal dev_deps['babel-plugin-transform-runtime'], '6.8.0'
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

  def test_package_json_contains_webpack_loaders_as_dependencies
    run_generator

    assert_file 'package.json' do |content|
      dev_deps = JSON.parse(content)['devDependencies']

      assert_equal dev_deps['babel-loader'], '6.2.4'
      assert_equal dev_deps['style-loader'], '0.13.1'
      assert_equal dev_deps['css-loader'], '0.23.1'
      assert_equal dev_deps['postcss-loader'], '0.9.1'
    end
  end

  def test_package_json_contains_webpack_plugins_as_dependencies
    run_generator

    assert_file 'package.json' do |content|
      dev_deps = JSON.parse(content)['devDependencies']

      assert_equal dev_deps['extract-text-webpack-plugin'], '1.0.1'
      assert_equal dev_deps['stats-webpack-plugin'], '0.3.1'
      assert_equal dev_deps['compression-webpack-plugin'], '0.3.1'

      assert_equal dev_deps['node-zopfli'], '1.4.0'
    end
  end

  def test_package_json_contains_postcss_plugins_as_dependencies
    run_generator

    assert_file 'package.json' do |content|
      dev_deps = JSON.parse(content)['devDependencies']

      assert_equal dev_deps['autoprefixer'], '6.3.6'
    end
  end

  def test_package_json_contains_additional_dependencies
    run_generator

    assert_file 'package.json' do |content|
      dev_deps = JSON.parse(content)['devDependencies']

      assert_equal dev_deps['js-yaml'], '3.6.0'
      assert_equal dev_deps['normalize-object'], '1.1.4'
    end
  end
end
