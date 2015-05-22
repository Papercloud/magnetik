require 'rails/generators/active_record'

module Magnetik
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        template 'initializer.rb', 'config/initializers/magnetik.rb'
      end
    end
  end
end
