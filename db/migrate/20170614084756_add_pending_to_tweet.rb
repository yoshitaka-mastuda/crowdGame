class AddPendingToTweet < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :pending, :boolean, default: true
    add_column :users, :pending_count, :integer, default: 0
  end
end
