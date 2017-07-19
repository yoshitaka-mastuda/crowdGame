class AddDeleteToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :delete, :boolean
  end
end
