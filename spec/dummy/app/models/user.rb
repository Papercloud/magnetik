class User < ActiveRecord::Base
  acts_as_magnetik_customer

  # Associations
  has_one :customer
end
