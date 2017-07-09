class AddAutoToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :auto_flag, :integer
  end
end
