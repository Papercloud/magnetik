class User < ActiveRecord::Base
  acts_as_magnetik_customer

  # Associations
  has_one :customer

  # Validations
  validates :email, presence: true
end
