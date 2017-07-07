class CreateDoingLists < ActiveRecord::Migration[5.1]
  def change
    create_table :doing_lists do |t|
      t.integer :user_id
      t.integer :tweet_id

      t.timestamps
    end
  end
end
