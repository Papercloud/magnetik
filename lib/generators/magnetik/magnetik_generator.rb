require 'rails/generators/named_base'

module Magnetik
  module Generators
    class MagnetikGenerator < ::Rails::Generators::NamedBase
      include ::Rails::Generators::ResourceHelpers

      namespace "magnetik"
      source_root File.expand_path('../templates', __FILE__)

      desc "Generates a credit card model (if it doesn't already exist) plus " <<
           "a migration convert the model with the given NAME to a magnetik "  <<
           "customer by adding in the stripe_customer_id field."

      hook_for :orm
    end
  end
end
