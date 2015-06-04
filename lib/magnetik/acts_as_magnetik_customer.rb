module Magnetik
  module ActsAsMagnetikCustomer
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_magnetik_customer(_options = {})
        include Magnetik::ActsAsMagnetikCustomer::LocalInstanceMethods

        has_many :credit_cards, as: :customer, class_name: 'Magnetik::CreditCard'
      end
    end

    module LocalInstanceMethods
      def has_stripe_customer?
        stripe_customer_id.present?
      end
    end
  end
end
