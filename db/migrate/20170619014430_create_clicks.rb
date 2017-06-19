class CreateClicks < ActiveRecord::Migration[5.1]
  def change
    create_table :clicks do |t|
      t.integer :user_id, null: false
      t.integer :tweet_id, null: false
      t.integer :state, null: false
      t.integer :vote_id

      t.timestamps
    end
    add_index :clicks, [:user_id, :tweet_id]
    add_index :clicks, :vote_id
  end
end
