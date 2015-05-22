class Make<%= table_name.camelize %>MagnetikCustomers < ActiveRecord::Migration
  def change
    change_table :<%= table_name %> do |t|
      t.string  :stripe_customer_id
    end
  end
end
