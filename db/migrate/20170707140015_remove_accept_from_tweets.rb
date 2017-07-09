class RemoveAcceptFromTweets < ActiveRecord::Migration[5.1]
  def change
    remove_column :tweets, :accept, :boolean
  end
end
