class RenameConfirmColumnToTweets < ActiveRecord::Migration[5.1]
  def change
    rename_column :tweets, :confirm, :accept
  end
end
