class CreateBehaviors < ActiveRecord::Migration[5.1]
  def change
    create_table :behaviors do |t|
      t.integer :user_id
      t.integer :tweet_id
      t.integer :state_id
      t.integer :vote_id

      t.timestamps
    end
  end
end
