class AddDeviseToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :devise, :string
  end
end
