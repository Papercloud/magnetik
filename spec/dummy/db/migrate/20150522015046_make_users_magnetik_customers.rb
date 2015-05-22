class MakeUsersMagnetikCustomers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string  :stripe_customer_id
    end
  end
end
