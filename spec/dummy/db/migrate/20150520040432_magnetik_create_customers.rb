class MagnetikCreateCustomers < ActiveRecord::Migration
  def change
    create_table :magnetik_customers do |t|
      t.string  :stripe_customer_id
      t.integer :owner_id
      t.string  :owner_type
      t.index   [:owner_id, :owner_type]

      t.timestamps null: false
    end
  end
end
