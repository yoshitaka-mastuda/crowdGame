class AddMessageToVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :message, :text
    add_column :votes, :category, :integer
  end
end
