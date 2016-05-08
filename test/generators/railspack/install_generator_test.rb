require 'rubygems'
require 'yaml'
require 'json'
require 'test_helper'
require 'generators/railspack/install_generator'

class RailspackGeneratorsInstallTest < Rails::Generators::TestCase
  include Railspack::TestSupport::Generator

  tests Railspack::Generators::InstallGenerator

  def test_railspack_config
    run_generator

    assert_file 'config/railspack.yml' do |content|
      config = YAML.load(content)

      %w(production development test).each do |env|
        dev_server = config[env]['dev_server']

        # development server

        assert_equal dev_server['enabled'], env == 'development'
        assert_equal dev_server['host'], 'localhost'
        assert_equal dev_server['port'], 3808
        assert_equal dev_server['https'], false

        # paths

        paths = config[env]['paths']

        assert_equal paths['output_path'], 'public/webpack'
        assert_equal paths['public_path'], 'webpack'
        assert_equal paths['manifest'], 'manifest.json'
      end
    end
  end

  def test_package_json
    run_generator

    assert_file 'package.json' do |content|
      package = JSON.parse(content)

      # name

      assert_equal(
        package['name'], Rails.application.class.name.underscore.dasherize
      )

      # version

      assert_equal package['version'], '1.0.0'

      # private

      assert_equal package['private'], true

      # scripts

      assert_equal(
        package['scripts']['build'],
        '$(npm bin)/webpack --config config/webpack.config.js --bail'
      )
      assert_equal(
        package['scripts']['server'],
        '$(npm bin)/webpack-dev-server --config config/webpack.config.js --inline --hot'
      )

      # development dependencies

      dev_deps = package['devDependencies']

      assert_equal dev_deps['babel-core'], '6.8.0'
      assert_equal dev_deps['babel-register'], '6.8.0'
      assert_equal dev_deps['babel-preset-es2015'], '6.6.0'
      assert_equal dev_deps['babel-plugin-transform-runtime'], '6.8.0'

      assert_equal dev_deps['webpack'], '1.13.0'
      assert_equal dev_deps['webpack-dev-server'], '1.14.1'

      assert_equal dev_deps['babel-loader'], '6.2.4'
      assert_equal dev_deps['style-loader'], '0.13.1'
      assert_equal dev_deps['css-loader'], '0.23.1'
      assert_equal dev_deps['postcss-loader'], '0.9.1'

      assert_equal dev_deps['extract-text-webpack-plugin'], '1.0.1'
      assert_equal dev_deps['stats-webpack-plugin'], '0.3.1'
      assert_equal dev_deps['compression-webpack-plugin'], '0.3.1'

      assert_equal dev_deps['node-zopfli'], '1.4.0'

      assert_equal dev_deps['autoprefixer'], '6.3.6'

      assert_equal dev_deps['js-yaml'], '3.6.0'
      assert_equal dev_deps['normalize-object'], '1.1.4'
    end
  end

  def test_webpack_config
    run_generator

    assert_file 'config/webpack.config.js'
  end

  def test_procfile
    run_generator

    assert_file 'Procfile' do |content|
      runners = content.lines.map(&:strip)
      version_with_preloader = Gem::Version.new('4.1.0')
      current_version = Gem::Version.new(Rails.version)

      if current_version < version_with_preloader
        assert_includes runners, 'rails: bundle exec rails s -p $PORT'
      else
        assert_includes runners, 'rails: bin/rails s -p $PORT'
      end

      assert_includes runners, 'webpack: npm install && npm run server'
    end
  end

  def test_existing_procfile
    File.open(File.join(temp_directory, 'Procfile'), 'w') do |file|
      file.write "rails: custom rails runner\n"
    end

    run_generator ['--force']

    assert_file 'Procfile' do |content|
      runners = content.lines.map(&:strip)

      assert_includes runners, 'rails: custom rails runner'
      assert_includes runners, 'webpack: npm install && npm run server'
    end
  end
end
