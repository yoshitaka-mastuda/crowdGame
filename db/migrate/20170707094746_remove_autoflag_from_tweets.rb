class RemoveAutoflagFromTweets < ActiveRecord::Migration[5.1]
  def change
    remove_column :tweets, :auto_flag, :binary
  end
end
