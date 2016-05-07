require 'test_helper'
require 'generators/railspack/install_generator'

class RailspackGeneratorsInstallPackageTest < Rails::Generators::TestCase
  include Railspack::TestSupport::Generator

  tests Railspack::Generators::InstallGenerator

  def test_generate_a_webpack_config
    run_generator

    assert_file 'config/webpack.config.js'
  end
end
