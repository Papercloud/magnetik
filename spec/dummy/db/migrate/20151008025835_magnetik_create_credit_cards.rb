class MagnetikCreateCreditCards < ActiveRecord::Migration
  def change
    create_table :magnetik_credit_cards do |t|
      t.string  :stripe_card_id, null: false
      t.string  :last_4_digits, null: false
      t.string  :exp_month, null: false
      t.string  :exp_year, null: false
      t.string  :brand, null: false
      t.boolean :is_default
      t.integer :customer_id, null: false
      t.string  :customer_type, null: false
      t.index   [:customer_id, :customer_id]
      t.string  :name

      t.timestamp :last_validated_at, null: false
      t.timestamps null: false
    end
  end
end
