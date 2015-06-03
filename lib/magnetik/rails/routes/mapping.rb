module Magnetik
  module Rails
    class Routes
      class Mapping
        attr_accessor :controllers, :as, :skips

        def initialize
          @controllers = {
            credit_cards: 'magnetik/credit_cards',
          }

          @as = {}
          @skips = []
        end

        def [](routes)
          {
            controllers: @controllers[routes],
            as: @as[routes]
          }
        end

        def skipped?(controller)
          @skips.include?(controller)
        end
      end
    end
  end
end
