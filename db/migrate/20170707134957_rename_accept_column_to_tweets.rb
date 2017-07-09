class RenameAcceptColumnToTweets < ActiveRecord::Migration[5.1]
  def change
    change_column_default :tweets, :accept, nil
  end
end
