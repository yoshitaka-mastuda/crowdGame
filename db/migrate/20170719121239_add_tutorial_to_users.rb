class AddTutorialToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :tutorial, :integer, default: 0
  end
end
