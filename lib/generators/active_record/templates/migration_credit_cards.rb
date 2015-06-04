class MagnetikCreateCreditCards < ActiveRecord::Migration
  def change
    create_table :magnetik_credit_cards do |t|
      t.string  :stripe_card_id
      t.string  :last_4_digits
      t.string  :exp_month
      t.string  :exp_year
      t.string  :brand
      t.boolean :is_default
      t.integer :customer_id
      t.string  :customer_type
      t.index   [:customer_id, :customer_id]
      t.string  :name

      t.timestamps null: false
    end
  end
end
