require 'rails/generators'

module Pcloud
  module Generators
    class PcloudGenerator < ::Rails::Generators::Base
      desc 'Generates a pcloud initializer file.'

      source_root File.expand_path("..", __FILE__)

      def copy_initializer_file
        copy_file "pcloud.rb", "config/initializers/pcloud.rb"
      end
    end
  end
end
