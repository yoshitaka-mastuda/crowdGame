class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.integer :state_id
      t.text :state_name

      t.timestamps
    end
  end
end
