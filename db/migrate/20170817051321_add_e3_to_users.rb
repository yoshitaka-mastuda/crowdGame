class AddE3ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :evaluation_count4, :integer, default:0
  end
end
