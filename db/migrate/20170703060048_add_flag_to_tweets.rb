class AddFlagToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :doing_flag, :integer
  end
end
