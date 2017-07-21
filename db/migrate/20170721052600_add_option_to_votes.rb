class AddOptionToVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :option, :text
  end
end
