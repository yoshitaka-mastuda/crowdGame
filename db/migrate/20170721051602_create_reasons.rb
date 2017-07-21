class CreateReasons < ActiveRecord::Migration[5.1]
  def change
    create_table :reasons do |t|
      t.integer :reason_id
      t.text :name

      t.timestamps
    end
  end
end
