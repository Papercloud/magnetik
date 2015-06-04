class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :user_id, index: true

      t.timestamps null: false
    end
  end
end
