class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :tweet_id
      t.integer :evaluation

      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :tweet_id
    add_index :votes, [:user_id, :tweet_id], unique: true
  end
end
