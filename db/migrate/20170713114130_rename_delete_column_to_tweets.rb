class RenameDeleteColumnToTweets < ActiveRecord::Migration[5.1]
  def change
    rename_column :tweets, :delete, :delete_flag
  end
end
