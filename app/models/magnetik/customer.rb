module Magnetik
  class Customer < ActiveRecord::Base
    # Associations:
    has_many :credit_cards
    belongs_to :owner, polymorphic: true

    # Validations:
    validates :stripe_customer_id, presence: true
    validates :owner_id, presence: true
    validates :owner_type, presence: true
  end
end