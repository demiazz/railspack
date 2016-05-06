require 'fileutils'

module Railspack
  module TestSupport
    module Generator
      def teardown
        return unless File.exist?(Generator.temp_directory)

        FileUtils.rm_rf(Generator.temp_directory)
      end

      def self.temp_directory
        File.expand_path('../../../tmp', __FILE__)
      end

      def self.included(mod)
        mod.destination temp_directory

        mod.setup :prepare_destination
      end
    end
  end
end
