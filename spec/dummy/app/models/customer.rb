class Customer < ActiveRecord::Base
  acts_as_magnetik_customer

  # Associations
  belongs_to :user
end
