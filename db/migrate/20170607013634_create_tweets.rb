class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.text :text
      t.integer :tweet_id

      t.timestamps
    end
  end
end
