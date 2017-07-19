class AddVersionToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :version, :integer
  end
end
