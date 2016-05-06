require 'test_helper'
require 'yaml'
require 'json'
require 'generators/railspack/install_generator'

class RailspackGeneratorsInstallConfigTest < Rails::Generators::TestCase
  include Railspack::TestSupport::Generator

  tests Railspack::Generators::InstallGenerator

  def test_generate_a_railspack_config
    run_generator

    assert_file 'config/railspack.yml'
  end

  def test_railspack_config_contains_a_dev_server_settings
    run_generator

    assert_file 'config/railspack.yml' do |content|
      config = YAML.load(content)

      %w(production development test).each do |env|
        assert_equal config[env]['dev_server'], {
          'enabled' => env == 'development',
          'host' => 'localhost',
          'port' => 3808,
          'https' => false
        }
      end
    end
  end

  def test_railspack_config_contains_a_path_settings
    run_generator

    assert_file 'config/railspack.yml' do |content|
      config = YAML.load(content)

      %w(production development test).each do |env|
        assert_equal config[env]['paths'], {
          'output_path' => 'public/webpack',
          'public_path' => 'webpack',
          'manifest' => 'manifest.json'
        }
      end
    end
  end
end
