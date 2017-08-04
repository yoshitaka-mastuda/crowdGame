class RenameOptionColumnToVotes < ActiveRecord::Migration[5.1]
  def change
    rename_column :votes, :option, :option_answer
  end
end
