class ChangeColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :evaluation_count3, :integer, default:0
  end
end
