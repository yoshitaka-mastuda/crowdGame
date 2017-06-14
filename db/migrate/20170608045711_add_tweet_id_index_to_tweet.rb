class AddTweetIdIndexToTweet < ActiveRecord::Migration[5.1]
  def change
    add_index :tweets, :tweet_id, unique: :true
  end
end
