class AddDeletecountToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :delete_count, :integer
  end
end
