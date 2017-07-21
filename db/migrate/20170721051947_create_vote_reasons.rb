class CreateVoteReasons < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_reasons do |t|
      t.integer :vote_id
      t.integer :reason_id

      t.timestamps
    end
  end
end
