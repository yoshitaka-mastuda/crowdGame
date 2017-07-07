class RemoveFlagFromTweets < ActiveRecord::Migration[5.1]
  def change
    remove_column :tweets, :doing_flag, :integer
  end
end
