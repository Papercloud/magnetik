require 'magnetik/rails/routes/mapping'
require 'magnetik/rails/routes/mapper'

module Magnetik
  module Rails
    class Routes
      module Helper
        def mount_magnetik(options = {}, &block)
          Magnetik::Rails::Routes.new(self, &block).generate_routes!(options)
        end
      end

      def self.install!
        ActionDispatch::Routing::Mapper.send :include, Magnetik::Rails::Routes::Helper
      end

      attr_accessor :routes

      def initialize(routes, &block)
        @routes, @block = routes, block
      end

      def generate_routes!(options)
        @mapping = Mapper.new.map(&@block)
        routes.scope options[:scope] || '', as: 'magnetik' do
          map_route(:credit_cards, :credit_card_routes)
        end
      end

      private

      def map_route(name, method)
        unless @mapping.skipped?(name)
          send method, @mapping[name]
        end
      end

      def credit_card_routes(mapping)
        routes.resources(
          :credit_cards,
          controller: mapping[:controllers],
          as: :credit_cards,
          path: 'credit_cards',
          only: [:index, :create, :update, :destroy],
        )

        routes.put    'credit_cards/:token', controller: mapping[:controllers], action: :register
        routes.delete 'credit_cards/:token', controller: mapping[:controllers], action: :deregister
      end
    end
  end
end
