module Magnetik
  class CreditCard < ActiveRecord::Base
    # Associations:
    belongs_to :customer

    # Validations:
    validates :customer_id, presence: true
    validates :stripe_card_id, presence: true
    validates :last_4_digits, presence: true
    validates :exp_month, presence: true
    validates :exp_year, presence: true
    validates :brand, presence: true
  end
end