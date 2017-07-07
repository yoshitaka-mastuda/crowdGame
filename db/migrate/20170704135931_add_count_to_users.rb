class AddCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :evaluation_count, :integer, default: 0
    add_column :users, :total_count, :integer, default: 0
  end
end
