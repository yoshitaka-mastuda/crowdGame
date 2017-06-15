class AddRejectCountToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :reject_count, :integer, default: 0
    add_column :tweets, :accept_count, :integer, default: 0
    add_column :tweets, :votes_count, :integer, default: 0
  end
end
