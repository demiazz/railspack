require 'test_helper'
require 'yaml'
require 'generators/railspack/install_generator'

class Railspack::Generators::InstallGeneratorTest < Rails::Generators::TestCase
  destination File.expand_path('../../../../tmp', __FILE__)

  tests Railspack::Generators::InstallGenerator

  setup :prepare_destination

  def test_generate_a_railspack_config
    run_generator

    assert_file 'config/railspack.yml' do |content|
      config = YAML.load(content)

      assert_equal config['production'], {
        'binary' => {
          'webpack' => 'node_modules/.bin/webpack',
          'webpack_dev_server' => 'node_modules/.bin/webpack-dev-server'
        },
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
        'binary' => {
          'webpack' => 'node_modules/.bin/webpack',
          'webpack_dev_server' => 'node_modules/.bin/webpack-dev-server'
        },
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
        'binary' => {
          'webpack' => 'node_modules/.bin/webpack',
          'webpack_dev_server' => 'node_modules/.bin/webpack-dev-server'
        },
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

    assert_file 'package.json'
  end
end
