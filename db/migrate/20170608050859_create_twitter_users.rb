class CreateTwitterUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :twitter_users do |t|
      t.string :name, null: :false
      t.integer :twitter_user_id, unique: :true, null: :false
      t.string :screen_name, null: :false
      t.string :location
      t.string :description

      t.timestamps
    end
  end
end
