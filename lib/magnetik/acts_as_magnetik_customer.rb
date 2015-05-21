module Magnetik
  module ActsAsMagnetikCustomer
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_magnetik_customer(_options = {})
        has_one :customer, as: :owner, class_name: 'Magnetik::Customer'
        has_many :credit_cards, through: :customer, class_name: 'Magnetik::CreditCard'
      end
    end
  end
end
