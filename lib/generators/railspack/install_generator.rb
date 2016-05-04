module Railspack
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Install everything you need for a basic railspack integration'

      source_root File.expand_path('../../templates', __FILE__)

      def create_railspack_config
        copy_file 'railspack.yml', 'config/railspack.yml'
      end

      def create_package_json
        copy_file 'package.json', 'package.json'
      end
    end
  end
end
