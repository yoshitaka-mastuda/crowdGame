class AddConfirmToTweet < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :confirm, :boolean, default: false
    add_column :users, :confirm_count, :integer, default: 0
    add_column :users, :tweet_count, :integer, default: 0
    add_index :tweets, [:confirm, :user_id]

  end
end
