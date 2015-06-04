class MakeCustomersMagnetikCustomers < ActiveRecord::Migration
  def change
    change_table :customers do |t|
      t.string  :stripe_customer_id
    end
  end
end
