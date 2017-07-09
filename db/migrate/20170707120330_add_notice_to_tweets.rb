class AddNoticeToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :notice_flag, :integer, default: 0
  end
end
