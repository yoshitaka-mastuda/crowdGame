class AddPointToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :accept_point, :integer
    add_column :users, :evaluation_point, :integer
    add_column :users, :total_point, :integer
  end
end
