class RemoveCategoryFromVotes < ActiveRecord::Migration[5.1]
  def change
    remove_column :votes, :category_id, :integer
  end
end
