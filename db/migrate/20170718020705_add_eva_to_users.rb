class AddEvaToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :evaluation_count2, :integer, default: 0
  end
end
