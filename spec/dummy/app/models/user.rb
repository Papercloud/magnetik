class User < ActiveRecord::Base
  acts_as_magnetik_customer

  # Associations
  has_one :customer

  # Validations
  validates :email, presence: true

  def stripe_description
    'Magnetik Customer'
  end
end
