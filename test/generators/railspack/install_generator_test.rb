require 'test_helper'
require 'yaml'
require 'json'
require 'generators/railspack/install_generator'

class Railspack::Generators::InstallGeneratorTest < Rails::Generators::TestCase
  include Railspack::TestSupport::Generator

  tests Railspack::Generators::InstallGenerator

  def test_generate_a_railspack_config
    run_generator

    assert_file 'config/railspack.yml' do |content|
      config = YAML.load(content)

      assert_equal config['production'], {
        'dev_server' => {
          'enabled' => false,
          'host' => 'localhost',
          'port' => 3808,
          'https' => false
        },
        'paths' => {
          'output_path' => 'public/webpack',
          'public_path' => 'webpack',
          'manifest' => 'manifest.json'
        }
      }

      assert_equal config['development'], {
        'dev_server' => {
          'enabled' => true,
          'host' => 'localhost',
          'port' => 3808,
          'https' => false
        },
        'paths' => {
          'output_path' => 'public/webpack',
          'public_path' => 'webpack',
          'manifest' => 'manifest.json'
        }
      }

      assert_equal config['test'], {
        'dev_server' => {
          'enabled' => false,
          'host' => 'localhost',
          'port' => 3808,
          'https' => false
        },
        'paths' => {
          'output_path' => 'public/webpack',
          'public_path' => 'webpack',
          'manifest' => 'manifest.json'
        }
      }
    end
  end

  def test_generate_a_package_json
    run_generator

    assert_file 'package.json' do |content|
      package = JSON.parse(content)
      dev_deps = package['devDependencies']
      application_name = Rails.application.class.name.underscore.dasherize

      assert_equal package['name'], application_name
      assert_equal package['version'], '1.0.0'
      assert_equal package['private'], true

      assert_equal dev_deps, {
        'webpack' => '1.13.0',
        'webpack-dev-server' => '1.14.1'
      }
    end
  end
end
