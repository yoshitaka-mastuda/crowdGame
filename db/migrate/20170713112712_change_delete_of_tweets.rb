class ChangeDeleteOfTweets < ActiveRecord::Migration[5.1]
  def change
    change_column :tweets, :delete, :boolean, default: 0
  end
end
