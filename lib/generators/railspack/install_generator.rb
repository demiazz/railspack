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
        unless File.exist?(File.join(destination_root, 'Procfile'))
          spring = Gem::Version.new(Rails.version) >= Gem::Version.new('4.1.0')

          copy_file "Procfile.#{spring ? 'spring' : 'default'}", 'Procfile'
        end

        append_to_file 'Procfile' do
          'webpack: npm install && npm run server'
        end
      end

      private

      def application_name
        Rails.application.class.name.underscore.dasherize
      end
    end
  end
end
