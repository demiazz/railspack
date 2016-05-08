require 'fileutils'

module Railspack
  module TestSupport
    module Generator
      def cleanup
        return unless File.exist?(temp_directory)

        FileUtils.rm_rf(temp_directory)
      end

      def temp_directory
        Generator.temp_directory
      end

      def self.temp_directory
        File.expand_path('../../../tmp', __FILE__)
      end

      def self.included(mod)
        mod.destination temp_directory

        mod.setup :prepare_destination
        mod.teardown :cleanup
      end
    end
  end
end
