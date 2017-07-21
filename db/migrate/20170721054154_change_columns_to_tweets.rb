class ChangeColumnsToTweets < ActiveRecord::Migration[5.1]
  def change
    change_column :tweets, :version, :integer, default:0
    change_column :tweets, :delete_count, :integer, default:0
  end
end
