module Railspack
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Install everything you need for a basic railspack integration'

      source_root File.expand_path('../../templates', __FILE__)

      def generate_railspack_config
        copy_file 'railspack.yml', 'config/railspack.yml'
      end
    end
  end
end
