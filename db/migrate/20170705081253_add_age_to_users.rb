class AddAgeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :age, :string
    add_column :users, :residence, :string
    add_column :users, :job, :string
    add_column :users, :browser, :string
  end
end
