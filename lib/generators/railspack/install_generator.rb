require 'rubygems'

module Railspack
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Install everything you need for a basic railspack integration'

      source_root File.expand_path('../../templates', __FILE__)

      def create_railspack_config
        copy_file 'railspack.yml', 'config/railspack.yml'
      end

      def create_package_json
        template 'package.json', 'package.json'
      end

      def create_webpack_config
        copy_file 'webpack.config.js', 'config/webpack.config.js'
      end

      def create_procfile
        version_with_preloader = Gem::Version.new('4.1.0')
        current_version = Gem::Version.new(Rails.version)

        if current_version < version_with_preloader
          copy_file 'Procfile.default', 'Procfile'
        else
          copy_file 'Procfile.preloader', 'Procfile'
        end
      end

      private

      def application_name
        Rails.application.class.name.underscore.dasherize
      end
    end
  end
end
