class RenameCategoryColumnToVotes < ActiveRecord::Migration[5.1]
  def change
    rename_column :votes, :category, :category_id
  end
end
