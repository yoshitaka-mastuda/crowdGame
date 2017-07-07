class CreateVoteCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_categories do |t|
      t.integer :vote_id
      t.integer :category_id

      t.timestamps
    end
  end
end
