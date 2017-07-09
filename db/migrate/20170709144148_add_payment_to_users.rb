class AddPaymentToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :payment, :integer, default: 0
  end
end
