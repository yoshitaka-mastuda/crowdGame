class AddTwitterUserIdToTweet < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :twitter_user_id, :integer
  end
end
