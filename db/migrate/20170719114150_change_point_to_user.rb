class ChangePointToUser < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :accept_point, :integer, default: 0
    change_column :users, :evaluation_point, :integer, default: 0
    change_column :users, :total_point, :integer, default: 0
  end
end
