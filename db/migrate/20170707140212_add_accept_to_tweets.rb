class AddAcceptToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :accept, :boolean, default: 0
    add_column :tweets, :reject, :boolean, default: 0
  end
end
