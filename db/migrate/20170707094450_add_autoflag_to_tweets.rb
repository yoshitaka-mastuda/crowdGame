class AddAutoflagToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :auto_flag, :binary
  end
end
